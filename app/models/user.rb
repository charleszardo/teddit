# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]

  validates :username, :email, presence: true
  validates :password_digest, :session_token, :slug, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  has_many :subs, foreign_key: :moderator_id
  has_many :posts, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  has_many :votes, foreign_key: :voter_id
  has_many :subscriptions
  has_many :subscribed_subs, through: :subscriptions, source: :sub
  has_many :subscribed_subs_posts, through: :subscribed_subs, source: :posts
  has_many :comment_votes, through: :comments, source: :votes
  has_many :post_votes, through: :posts, source: :votes

  after_initialize :ensure_session_token

  def self.find_by_username_and_password(username, password)
    user = User.find_by_username(username)

    user && user.is_password?(password) ? user : nil
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = generate_token
    self.save
    self.session_token
  end

  def subscribed?(sub)
    subscribed_subs.include?(sub)
  end

  def owns?(item)
    assoc = item.class.name.downcase.pluralize
    self.send(assoc).include?(item)
  end

  def vote_count
    # TODO improve querying
    comments_vote_count + posts_vote_count
  end

  def comments_vote_count
    comment_votes.sum(:value)
  end

  def posts_vote_count
    post_votes.sum(:value)
  end

  def get_scores(collection)
    collection.select("#{table_name}.*, COALESCE(SUM(votes.value), 0) AS vote_score")
        .joins("LEFT JOIN votes ON votes.votable_id = #{table_name}.id AND votes.votable_type = '#{table_name.classify}'")
        .group("#{table_name}.id")
        .order("vote_score DESC")
  end

  def get_hot_scores(collection)
    collection.select("#{table_name}.*, COALESCE(SUM(votes.value), 0) AS vote_score")
        .joins("LEFT JOIN votes ON votes.votable_id = #{table_name}.id AND votes.votable_type = '#{table_name.classify}'")
        .where("votes.created_at > :hotness_range OR votes.created_at IS NULL", :hotness_range  => HOTNESS_RANGE)
        .group("#{table_name}.id")
        .order("vote_score DESC")
  end

  private
  def generate_token
    SecureRandom::urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= generate_token
  end
end

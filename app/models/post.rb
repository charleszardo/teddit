# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, :author, presence: true
  validates :subs, length: { minimum: 1 , message: "please select at least one sub"}
  validates :slug, presence: true, uniqueness: true

  belongs_to :author, class_name: "User"

  has_many :postings, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :postings, source: :sub
  has_many :comments
  has_many :votes, as: :votable

  def self.all_with_scores
    Post.select("posts.*, SUM(votes.value) AS vote_score")
                 .joins(:votes)
                 .group("posts.id")
                 .order("vote_score DESC")
  end

  def author_name
    self.author.username
  end

  def sub_name
    self.sub.title
  end

  def is_owner?(user)
    self.author == user
  end

  def comments_by_parent
    comments_hash = Hash.new { |h, k| h[k] = []}

    self.comments.includes(:author).each do |comment|
      comments_hash[comment.parent_comment_id] << comment
    end

    comments_hash
  end

  def score
    Vote.select("value")
        .where(votable_id: self.id, votable_type: self.class.to_s)
        .inject(0) { |sum, num| sum + num.value }
  end

  def video
    return nil if self.url.nil?

    params = Rack::Utils.parse_query URI(self.url).query
    @video = Yt::Video.new id: params["v"]
  end
end

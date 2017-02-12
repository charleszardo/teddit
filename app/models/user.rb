class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # has_many :subs, foreign_key: :moderator_id
  # has_many :posts, foreign_key: :author_id
  # has_many :comments, foreign_key: :author_id
  # has_many :votes, foreign_key: :voter_id
  # has_many :subscriptions
  # has_many :subscribed_subs, through: :subscriptions, source: :sub
  # has_many :subscribed_subs_posts, through: :subscribed_subs, source: :posts
  # has_many :comment_votes, through: :comments, source: :votes
  # has_many :post_votes, through: :posts, source: :votes

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
end

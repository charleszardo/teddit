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
  validates :title, :author, presence: true
  validates :subs, length: { minimum: 1 , message: "please select at least one sub"}

  belongs_to :author, class_name: "User"

  has_many :postings, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :postings, source: :sub
  has_many :comments
  has_many :votes, as: :votable

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
end

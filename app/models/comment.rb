# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  author_id         :integer          not null
#  post_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_comment_id :integer
#

class Comment < ActiveRecord::Base
  include Voting

  validates :content, presence: true

  belongs_to :post
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_comment_id

  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id

  def author_username
    self.author.username
  end
end

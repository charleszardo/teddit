class Comment < ActiveRecord::Base
  validates :content, :author, presence: true

  belongs_to :author, class_name: "User"
  belongs_to :post
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_comment_id

  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id

  def author_username
    self.author.username
  end
end

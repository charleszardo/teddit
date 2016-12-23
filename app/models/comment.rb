class Comment < ActiveRecord::Base
  validates :content, :author, presence: true

  belongs_to :author, class_name: "User"
end

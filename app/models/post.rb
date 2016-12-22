class Post < ActiveRecord::Base
  validates :title, :sub, :author

  belongs_to :sub
  belongs_to :author, class_name: "User"
end

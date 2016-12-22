class Post < ActiveRecord::Base
  validates :title, :sub, :author

  belongs_to :sub
  belongs_to :author, class_name: "User"

  def author_name
    self.author.username
  end

  def sub_name
    self.sub.title
  end

  def is_owner?(user)
    self.author == user
  end
end

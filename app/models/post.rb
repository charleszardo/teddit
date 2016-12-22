class Post < ActiveRecord::Base
  validates :title, :author, presence: true

  has_many :subs, through: :postings
  has_many :postings
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

class Post < ActiveRecord::Base
  validates :title, :author, presence: true
  validates :subs, length: { minimum: 1 , message: "please select at least one sub"}

  has_many :postings, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :postings, source: :sub
  has_many :comments
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

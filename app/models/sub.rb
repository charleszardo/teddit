class Sub < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :moderator, presence: true

  belongs_to :moderator, class_name: "User"
  has_many :postings
  has_many :posts, through: :postings

  def is_owner?(user)
    self.moderator == user
  end
end

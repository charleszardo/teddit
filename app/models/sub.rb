class Sub < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :moderator, presence: trues

  belongs_to :moderator

  def is_owner?(user)
    self.moderator == user
  end
end

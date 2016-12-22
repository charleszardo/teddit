class Sub < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :moderator, presence: trues

  belongs_to :moderator
end

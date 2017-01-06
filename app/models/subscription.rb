class Subscription < ActiveRecord::Base
  validates :user_id, :sub_id, presence: true
  validates :user_id, uniqueness: { scope: :sub_id }

  belongs_to :user
  belongs_to :sub
end

# == Schema Information
#
# Table name: subs
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text
#  moderator_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Sub < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, :slug, presence: true, uniqueness: true
  validates :moderator, presence: true

  belongs_to :moderator, class_name: "User"
  has_many :postings, dependent: :destroy, inverse_of: :sub
  has_many :posts, through: :postings, source: :post

  def is_owner?(user)
    self.moderator == user
  end
end

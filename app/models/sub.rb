class Sub < ActiveRecord::Base
  # extend FriendlyId
  # friendly_id :title, use: [:slugged, :finders]

  # validates :title, :slug, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  validates :moderator, presence: true

  belongs_to :moderator, class_name: "User"
  # has_many :postings, dependent: :destroy, inverse_of: :sub
  # has_many :posts, through: :postings, source: :post
  # has_many :subscriptions
  # has_many :subscribers, through: :subscriptions, source: :user
end

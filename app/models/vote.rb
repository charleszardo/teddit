class Vote < ActiveRecord::Base
  validates :value, :voter_id, :votable_id, :votable_type, presence: true
  validates :voter_id, :uniqueness => {:scope => [:votable_id, :votable_type]}

  belongs_to :voter, class_name: "User"
  belongs_to :votable, polymorphic: true
end

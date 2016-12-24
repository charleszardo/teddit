# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  value        :integer          not null
#  voter_id     :integer          not null
#  votable_id   :integer
#  votable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ActiveRecord::Base
  validates :value, :voter_id, :votable_id, :votable_type, presence: true
  validates :voter_id, :uniqueness => {:scope => [:votable_id, :votable_type]}

  belongs_to :voter, class_name: "User"
  belongs_to :votable, polymorphic: true
end

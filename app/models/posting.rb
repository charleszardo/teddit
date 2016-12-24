# == Schema Information
#
# Table name: postings
#
#  id         :integer          not null, primary key
#  post_id    :integer          not null
#  sub_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Posting < ActiveRecord::Base
  validates :post, :sub, presence: true
  validates :post, uniqueness: { scope: :sub_id }

  belongs_to :post, inverse_of: :postings
  belongs_to :sub, inverse_of: :postings
end

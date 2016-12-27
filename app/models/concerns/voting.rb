module Voting
  extend ActiveSupport::Concern

  HOTNESS_COEFFICIENT = 5
  HOTNESS_RANGE = 5.days.ago

  included do
    has_many :votes, as: :votable
    belongs_to :author, class_name: "User"

    validates :author, presence: true
  end

  def score
    get_score.inject(0) { |sum, vote| sum + vote.value }
  end

  def get_score
    Vote.select("value, created_at")
        .where(votable_id: self.id, votable_type: self.class.to_s)
  end

  def hotness
    get_score.inject(0) do |sum, vote|
      sum + (vote.value * (vote.created_at > HOTNESS_RANGE ? HOTNESS_COEFFICIENT : 1))
    end
  end

  module ClassMethods
    def get_scores(collection)
      collection.select("#{table_name}.*, SUM(votes.value) AS vote_score")
          .joins("LEFT JOIN votes ON votes.votable_id = #{table_name}.id AND votes.votable_type = '#{table_name.classify}'")
          .group("#{table_name}.id")
          .order("vote_score DESC")
    end

    def table_name
      self.name.underscore.pluralize
    end
  end
end

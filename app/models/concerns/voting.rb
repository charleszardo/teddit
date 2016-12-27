module Voting
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    belongs_to :author, class_name: "User"

    validates :author, presence: true
  end

  def score
    Vote.select("value")
        .where(votable_id: self.id, votable_type: self.class.to_s)
        .inject(0) { |sum, num| sum + num.value }
  end

  module ClassMethods
    def with_scores(collection)
      collection.select("#{table_name}.*, SUM(votes.value) AS vote_score")
          .joins(:votes)
          .group("#{table_name}.id")
          .order("vote_score DESC")
    end

    def table_name
      self.name.underscore.pluralize
    end
  end
end

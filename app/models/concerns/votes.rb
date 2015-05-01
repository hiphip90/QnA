module Votes
  module Votable
    extend ActiveSupport::Concern

    included do
      has_many :votes, as: :votable  
    end

    def rating
      votes.pluck(:value).sum
    end
  end

  module Voter
    extend ActiveSupport::Concern

    included do
      has_many :votes
    end

    def upvote(object)
      self.votes.create(value: 1, votable: object) unless has_voted_for?(object) || self.id == object.user_id
    end

    def downvote(object)
      self.votes.create(value: -1, votable: object) unless has_voted_for?(object) || self.id == object.user_id
    end

    def has_voted_for?(object)
      return true if votes.where(votable: object).any?
      false
    end

    def recall_vote(object)
      votes = self.votes.where(votable: object)
      votes.destroy_all if votes.any?
    end
  end
end
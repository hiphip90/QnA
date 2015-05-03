module Votes
  module Votable
    extend ActiveSupport::Concern

    included do
      has_many :votes, as: :votable  
    end

    def rating
      votes.sum(:value)
    end

    def upvote_by(voter)
      voter.votes.create(value: 1, votable: self) unless been_voted_by?(voter)
    end

    def downvote_by(voter)
      voter.votes.create(value: -1, votable: self) unless been_voted_by?(voter)
    end

    def been_voted_by?(voter)
      return true if voter.votes.where(votable: self).any?
      false
    end

    def recall_vote_by(voter)
      votes = voter.votes.where(votable: self)
      votes.destroy_all if votes.any?
    end
  end
end

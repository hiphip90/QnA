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
      self.votes.create(value: 1, votable: object)
    end

    def downvote(object)
      self.votes.create(value: -1, votable: object)
    end
  end
end
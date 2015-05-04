module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable  
  end

  def rating
    votes.sum(:value)
  end

  def upvote_by(voter)
    votes.create(value: 1, user: voter) unless been_voted_by?(voter)
  end

  def downvote_by(voter)
    votes.create(value: -1, user: voter) unless been_voted_by?(voter)
  end

  def been_voted_by?(voter)
    return true if votes.where(user: voter).any?
    false
  end

  def recall_vote_by(voter)
    votes.where(user: voter).destroy_all
  end
end

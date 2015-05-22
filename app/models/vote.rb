class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  after_create { |vote| Reputation.update(votable.user, "vote_#{votable_type.underscore}".to_sym, upvote: ( value == 1 ? true : false )) }
  after_destroy { |vote| Reputation.update(votable.user, "recall_#{votable_type.underscore}_vote".to_sym, upvote: ( value == 1 ? true : false )) }
end

module AffectsReputation
  module Answer
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Callbacks
      define_model_callbacks :accept, :recall_accept
   
      after_create { Reputation.update(user, calculate_reputation_for_create_or_destroy) }
      after_destroy { Reputation.update(user, calculate_reputation_for_create_or_destroy) }
      after_accept { Reputation.update(user, calculate_reputation_for_accept) }
      after_recall_accept { Reputation.update(user, calculate_reputation_for_accept) }
    end

    private
      def calculate_reputation_for_create_or_destroy
        reputation = 1
        reputation += 1 if first?
        reputation += 1 if to_own_question?
        reputation += 3 if accepted?
        self.persisted? ? (return reputation) : (return -1*reputation)
      end

      def calculate_reputation_for_accept
        reputation = (accepted? ? 3 : -3)
      end
  end

  module Vote
    extend ActiveSupport::Concern

    included do
      after_create { |vote| Reputation.update(votable.user, value) }
      after_destroy { |vote| Reputation.update(votable.user, 2*value) }
    end
  end
end

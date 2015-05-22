class Reputation
  REP_YIELD = {
    create_answer: 1,
    first_answer: 1,
    to_own_question: 1,
    accept_answer: 3,
    vote_answer: 1,
    vote_question: 2
  }

  class << self
    def update(target_user, action, options = default_options)
      reputation_yield = 0
      case action
        when :create_answer
          reputation_yield = calculate_yield_for_answer(options)
        when :destroy_answer
          reputation_yield = -1 * calculate_yield_for_answer(options)
        when :accept_answer
          reputation_yield = REP_YIELD[:accept_answer]
        when :recall_accept_answer
          reputation_yield = -1 * REP_YIELD[:accept_answer]
        when :vote_answer
          reputation_yield = options[:upvote] ? REP_YIELD[:vote_answer] : -1 * REP_YIELD[:vote_answer]
        when :vote_question
          reputation_yield = options[:upvote] ? REP_YIELD[:vote_question] : -1 * REP_YIELD[:vote_question]
        when :recall_answer_vote
          reputation_yield = options[:upvote] ? -1* REP_YIELD[:vote_answer] : REP_YIELD[:vote_answer]
        when :recall_question_vote
          reputation_yield = options[:upvote] ? -1* REP_YIELD[:vote_question] : REP_YIELD[:vote_question]
      end
      reputation = target_user.reputation + reputation_yield
      target_user.update(reputation: reputation)
    end

    private
      def calculate_yield_for_answer(options)
        reputation_yield = REP_YIELD[:create_answer]
        reputation_yield += REP_YIELD[:first_answer] if options[:first]
        reputation_yield += REP_YIELD[:to_own_question] if options[:to_own_question]
        reputation_yield += REP_YIELD[:accept_answer] if options[:accepted]
        reputation_yield
      end

      def default_options
        { first: false, to_own_question: false, accepted: false, upvote: false }
      end
  end
end
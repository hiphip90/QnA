class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    if user
      if user.admin?
        can :manage, :all
      else
        can :read, :all
        can :create, [Question, Answer, Comment]
        can :update, [Question, Answer], user: user
        can :destroy, [Question, Answer], user: user

        can :accept, Answer do |answer|
          answer.question.user_id == user.id && !answer.accepted?
        end

        alias_action :upvote, :downvote, to: :vote
        can :vote, [Question, Answer] do |votable|
          votable.user_id != user.id && !votable.been_voted_by?(user)
        end
        can :recall_vote, [Question, Answer] do |votable|
          votable.user_id != user.id && votable.been_voted_by?(user)
        end

        can :subscribe, Question
        can :subscribe_to, Question do |question|
          !user.subscribed_to?(question)
        end
      end
    else
      can :read, :all
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

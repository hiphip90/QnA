module Voting
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:upvote, :downvote, :recall_vote]
  end

  def upvote
    current_user.upvote @votable
    render 'shared/vote'
  end

  def downvote
    current_user.downvote @votable
    render 'shared/vote'
  end

  def recall_vote
    current_user.recall_vote @votable
    render 'shared/vote'
  end

  private

    def model_klass
      controller_name.classify.constantize
    end

    def get_votable
      @votable = model_klass.find(params[:id])
    end
end
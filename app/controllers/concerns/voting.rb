module Voting
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:upvote, :downvote, :recall_vote]
    before_action :authenticate_user!, except: [:index, :show]
  end

  def upvote
    @votable.upvote_by current_user unless @votable.user_id == current_user.id
    render 'shared/vote'
  end

  def downvote
    @votable.downvote_by current_user unless @votable.user_id == current_user.id
    render 'shared/vote'
  end

  def recall_vote
    @votable.recall_vote_by current_user unless @votable.user_id == current_user.id
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
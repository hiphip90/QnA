module Voting
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:upvote, :downvote]
  end

  def upvote
    current_user.upvote @votable
    render :vote
  end

  def downvote
    current_user.downvote @votable
    render :vote
  end

  private

    def model_klass
      controller_name.classify.constantize
    end

    def get_votable
      @votable = model_klass.find(params[:id])
    end
end
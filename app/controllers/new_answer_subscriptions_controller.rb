class NewAnswerSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def create
    @question = Question.find(params[:question_id])
    current_user.subscribe_to_new_answers(@question)
    render nothing: true
  end
end

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_answer_with_question, only: [:destroy, :update, :accept]
  after_action :publish_answer, only: :create

  respond_to :js
  
  include Voting
  
  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
    respond_with @answer
  end

  def update
    @answer.update(answer_params) if current_user.id == @answer.user_id
    respond_with @answer
  end

  def accept
    @answer.accept if current_user.id == @question.user_id
    respond_with @answer
  end

  private
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def get_answer_with_question
      @answer = Answer.find(params[:id])
      @question = @answer.question
    end

    def publish_answer
      Danthes.publish_to "/questions/#{@question.id}/answers", answer: render_to_string('answers/show.json.jbuilder') if @answer.valid?
    end
end

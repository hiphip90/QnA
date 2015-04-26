class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_answer, only: [:destroy, :update, :accept]
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question }
      else
        format.html { render 'questions/show' }
      end
      format.js {}
    end
  end

  def destroy
    @question = @answer.question
    if current_user.id == @answer.user_id
      @answer.destroy
    else
      render nothing: true, status: :bad_request
    end
  end

  def update
    @question = @answer.question
    if current_user.id == @answer.user_id
      @answer.update(answer_params)
    else
      render nothing: true, status: :bad_request
    end
  end

  def accept
    @question = Question.find(params[:question_id])
    if current_user.id == @question.user_id
      @answer.accept
    else
      render nothing: true, status: :bad_request
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def get_answer
      @answer = Answer.find(params[:id])
    end
end

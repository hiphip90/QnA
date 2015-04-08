class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answers = @question.answers.includes(:user)
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
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.id == @answer.user.id
      @answer.destroy
    else
      render nothing: true, status: :bad_request
    end
  end

  def update
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user.id
      @answer.update(answer_params)
    else
      render nothing: true, status: :bad_request
    end
  end

  def accept
    @answer = Answer.find(params[:id])
    @question = Question.find(params[:question_id])
    if !@question.has_accepted_answer? && current_user == @question.user
      @answer.update(accepted: true)
    else
      render nothing: true, status: :bad_request
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end

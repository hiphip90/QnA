class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @question = Question.find(params[:question_id])
    @new_answer = @question.answers.build(answer_params)
    @new_answer.user = current_user
    if @new_answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user.id
      @answer.destroy
      redirect_to @answer.question
    else
      redirect_to root_path
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end

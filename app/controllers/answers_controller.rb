class AnswersController < ApplicationController
  before_action :authenticate_user!
  
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
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user.id
      @answer.destroy
      redirect_to @answer.question
    else
      redirect_to root_path
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end

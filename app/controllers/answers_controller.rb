class AnswersController < ApplicationController
  def create
    user = User.find(answer_params[:user_id])
    question_id = params[:question_id]
    @answer = user.answers.build(answer_params)
    @answer.question_id = question_id
    if @answer.save
      redirect_to question_url(id: question_id)
    else
      render 'questions/show', id: question_id
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body, :user_id)
    end
end

class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end
  def new
    @question = Question.new
  end
  def show
    @question = Question.find(params[:id])
    @user = User.find(@question.user_id)
  end
  def create
    @user = User.find(question_params[:user_id])
    @question = @user.questions.build(question_params)
    if @question.save
      redirect_to @question
    else
      render 'new'
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :body, :user_id)
    end
end

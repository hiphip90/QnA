class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def index
    @questions = Question.includes(:user)
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.includes(:user)
    @answer = Answer.new
  end
  
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "You've successfully created a question!"
      redirect_to @question
    else
      render 'new'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    if current_user.id == @question.user.id
      @question.destroy
      flash[:success] = "You've successfully deleted a question!"
    end
    redirect_to root_path
  end

  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end

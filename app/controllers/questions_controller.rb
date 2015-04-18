class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :get_question, only: [:show, :update, :destroy]
  
  def index
    @questions = Question.includes(:user)
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answers = @question.answers.order('accepted DESC').includes(:user)
    @answer = Answer.new
    @answer.attachments.build
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

  def update
    if @question.user_id == current_user.id
      @question.update(question_params)
    else
      render nothing: true, status: 400
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
    end
    respond_to do |format|
      format.html do
        flash[:success] = "You've successfully deleted a question!"
        redirect_to root_path
      end
      format.js {}
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
    end

    def get_question
      @question = Question.find(params[:id])
    end
end

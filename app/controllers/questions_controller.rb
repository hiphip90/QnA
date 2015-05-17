class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :get_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create
  authorize_resource except: [:new, :create]

  respond_to :html, :js

  include Voting
  
  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def show
    @answers = @question.answers.includes(:user)
    respond_with(@question)
  end
  
  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private
    def build_answer
      @answer = @question.answers.build
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end

    def get_question
      @question = Question.find(params[:id])
    end

    def publish_question
      Danthes.publish_to "/questions", question: render_to_string('question.json.jbuilder') if @question.valid?
    end
end

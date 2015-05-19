class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @question = Question.find(params[:question_id])
    respond_with @question.answers
  end

  def show
    respond_with @answer = Answer.find(params[:id]), serializer: ShowAnswerSerializer, root: 'answer'
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)),
                            serializer: ShowAnswerSerializer, root: 'answer')
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
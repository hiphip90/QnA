class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with Question.all
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: ShowQuestionSerializer, root: 'question'
  end

  def create
    respond_with(@question = current_resource_owner.questions.create(question_params),
                            serializer: ShowQuestionSerializer, root: 'question')
  end

  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
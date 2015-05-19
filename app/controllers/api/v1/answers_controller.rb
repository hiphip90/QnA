class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @question = Question.find(params[:question_id])
    respond_with @question.answers
  end

  private
    def answer_params
      params.require(:question).permit(:title, :body)
    end
end
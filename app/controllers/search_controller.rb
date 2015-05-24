class SearchController < ApplicationController
  respond_to :html

  def search
    @questions = Question.search Condition.build_from_params(params[:search])
    respond_with @questions
  end
end
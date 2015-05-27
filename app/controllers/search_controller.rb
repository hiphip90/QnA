class SearchController < ApplicationController
  respond_to :html
  before_action :search_params

  def search
    @results = Finder.perform_search(search_params[:q], search_params[:scope])
    respond_with @results
  end

  private
    def search_params
      params[:search]
    end
end
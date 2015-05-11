class CommentsController < ApplicationController
  before_action :get_commentable
  before_action :authenticate_user!
  after_action :publish_comment

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  private
    def get_commentable
      @commentable = params[:commentable].classify.constantize.find(params["#{params[:commentable]}_id".to_sym])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def publish_comment
      Danthes.publish_to "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments", comment: render_to_string('comment.json.jbuilder') if @comment.valid?
    end
end

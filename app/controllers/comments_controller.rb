class CommentsController < ApplicationController
  before_action :get_commentable
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.js do
          Danthes.publish_to "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments", comment: render_to_string('comment.json.jbuilder')
          render nothing: true
        end
      else
        format.js
      end
    end
  end

  private
    def get_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @commentable = $1.classify.constantize.find(value)
        end
      end
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end

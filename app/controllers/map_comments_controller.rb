class MapCommentsController < ApplicationController
  def create
    @map_comment = MapComment.new(params[:map_comment])
    if @map_comment.save
      flash[:notice] = "Added Comment"
    else
      flash[:Alert] = "Could not add comment"
    end
    redirect_to params[:map_id]

  end
  def destroy

    redirect_to root_url, notice: "Comment Deleted!"
  end
  def update
  end
end

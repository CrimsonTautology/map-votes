class MapCommentsController < ApplicationController
  def create
    @map_comment = MapComment.new(params[:map_comment])
    @map_comment.map= Map.find(params[:map_id])
    @map_comment.user = current_user

    if @map_comment.save
      flash[:notice] = "Added Comment"
    else
      flash[:alert] = "Could not add comment"
    end
    redirect_to params[:map_id]

  end
  def destroy
    MapComment.find(params[:id]).destroy
    flash[:notice] = "Comment Deleted!"
    redirect_to params[:map_id]
  end

  def update
    @map_comment = MapComment.find(params[:id])
    if @map_comment.update_attributes(params[:map_comment])
      flash[:notice] = "Updated Comment"
    else
      flash[:alert] = "Could not update comment"
    end

    redirect_to params[:map_id]
  end
end

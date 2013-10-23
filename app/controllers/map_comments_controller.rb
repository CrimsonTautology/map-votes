class MapCommentsController < ApplicationController
  authorize_resource
  before_filter :find_map_comment, only: [:update, :destroy]

  def create
    user = current_user
    map= Map.find_by_name(params[:map_id])
    comment = params[:map_comment][:comment]

    if MapComment.write_message user, map, comment
      flash[:notice] = "Added Comment"
    else
      flash[:alert] = "Could not add comment"
    end
    redirect_to map

  end
  def destroy
    @map_comment.delete
    flash[:notice] = "Comment Deleted!"
    redirect_to @map
  end

  def update
    if @map_comment.update_attributes(params[:map_comment])
      flash[:notice] = "Updated Comment"
    else
      flash[:alert] = "Could not update comment"
    end

    redirect_to @map_comment.map
  end

  private
  def find_map_comment
    @map_comment = MapComment.find(params[:id])
    @map = @map_comment.map
  end

end

class MapsController < ApplicationController
  def index
    @maps = Map.find(:all, order: 'name')
    @map_types = @maps.group_by {|m| m.map_type}.sort
  end

  def show
    @map = Map.find_by_name(params[:id])
    @type = @map.map_type
  end

  def edit
  end
  def create_comment
    @map_comment = MapComment.new(params[:map_comment])
    if @map_comment.save
      flash[:notice] = "Added Comment"
    else
      flash[:Alert] = "Could not add comment"
    end
    redirect_to params[:id]

  end
  def destroy_comment

    redirect_to root_url, notice: "Comment Deleted!"
  end


end

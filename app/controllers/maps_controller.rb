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

  def vote
    value = params[:type] == "up" ? 1 : -1
    @map = Map.find(params[:id])
    @map.add_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Thank you for voting!"
  end


end

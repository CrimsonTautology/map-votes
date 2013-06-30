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


end

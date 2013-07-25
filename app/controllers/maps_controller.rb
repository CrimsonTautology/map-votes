class MapsController < ApplicationController
  before_filter :authorize, only: [:edit, :update, :new]
  def index
    @maps = Map.find(:all, order: 'name')
    @map_types = @maps.group_by {|m| m.map_type}.sort
  end

  def show
    @map = Map.find_by_name(params[:id])
  end

  def edit
    @map = Map.find_by_name(params[:id])
  end

  def update
    @map = Map.find_by_name(params[:id])
    if @map.update_attributes(params[:map])
      redirect_to action: 'show', id: @map
    else
      flash[:alert] = "Could not update map"
      render action: 'edit'
    end
  end

  def vote
    value =  0
    value =  1 if params[:type] == "up"
    value = -1 if params[:type] == "down"
    @map = Map.find_by_name(params[:id])
    Vote.cast_vote current_user, @map, value
    redirect_to :back, notice: "Thank you for voting!"
  end


end

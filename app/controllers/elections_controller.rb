class ElectionsController < ApplicationController
  def index
    @elections = Election.all
  end

  def active
  end

  def past
  end

  def show
  end

  def new
    @election = Election.new
  end

  def edit
  end

  def delete
  end

  def vote
  end
end

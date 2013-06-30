class MapCommentsController < ApplicationController
  def create

    redirect_to root_url, notice: "Comment Added!"
  end
  def destroy

    redirect_to root_url, notice: "Comment Deleted!"
  end
end

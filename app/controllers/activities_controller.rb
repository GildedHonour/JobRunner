class ActivitiesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @activities = Version.order("created_at DESC")
  end

  private
  def authenticate_admin!
    redirect_to root_url and return unless current_user.try(&:admin?)
  end
end

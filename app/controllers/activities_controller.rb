class ActivitiesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @activities = Version.order("created_at DESC")
  end
end
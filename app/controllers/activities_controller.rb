class ActivitiesController < ApplicationController
  def index
    @activities = Version.order("created_at DESC")
  end
end

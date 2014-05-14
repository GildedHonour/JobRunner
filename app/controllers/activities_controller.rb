class ActivitiesController < ApplicationController
  def index
    @activities = Version.where("whodunnit_email IS NOT NULL").order("created_at DESC")
  end
end

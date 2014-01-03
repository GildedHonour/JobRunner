class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :determine_layout

  private
  def determine_layout
    true ? "application" : "public"
  end
end
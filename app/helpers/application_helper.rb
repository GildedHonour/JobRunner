module ApplicationHelper
  def active_class_if_controller(controller_name)
    controller.controller_name == controller_name ? "active" : "inactive"
  end

  def human_boolean(boolean)
    boolean ? "Yes" : "No"
  end

  def back_url_or(url)
    (request.url == request.referrer) ? url : request.referrer
  end
end
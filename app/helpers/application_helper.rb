module ApplicationHelper
  def a_an_helper(word)
    %w(a e i o u).include?(word.first.downcase) ? "an" : "a"
  end

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

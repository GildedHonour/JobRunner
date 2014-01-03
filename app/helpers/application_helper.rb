module ApplicationHelper
  def active_class_if_controller(controller_name)
    controller.controller_name == controller_name ? "active" : "inactive"
  end
end

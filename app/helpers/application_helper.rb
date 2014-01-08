module ApplicationHelper
  def active_class_if_controller(controller_name)
    controller.controller_name == controller_name ? "active" : "inactive"
  end

  # A couple of simple view helpers
  # Human_boolean for Yes/No copy
  # Human_status for Active/Inactive/Unknown copy
  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
	end

	def human_status(status)
		if status == 0
			"Active"
		elsif status == 1
			"Inactive"
		else
			"(unknown)"
		end
	end
end

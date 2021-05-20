module AdminCurrent
	mattr_accessor :admin_current
	
end
class ApplicationController < ActionController::Base
	before_action :set_current_admin 
	def set_current_admin
		if current_admin
			AdminCurrent.admin_current = current_admin
		end
	end
	def after_sign_in_path_for(resource)
		stored_location_for(resource) ||
		if resource.is_a?(User)
			projects_new_path
		elsif resource.is_a?(Admin)
			rails_admin_path
		else
			posts_new_path
		end
	end
end

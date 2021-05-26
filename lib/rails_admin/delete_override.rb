module RailsAdmin
	module Config
		module Actions
			class DeleteOverride < RailsAdmin::Config::Actions::Base

				RailsAdmin::Config::Actions.register(self)

				register_instance_option :member do
					true
				end

				register_instance_option :http_methods do
					[:get, :delete]
				end

				register_instance_option :authorization_key do
					:destroy
				end


				register_instance_option :controller do
					Proc.new do
						if request.get? 
							#checking current admin role  super admin
							if current_admin.role =="Super Admin"
								# if gauth enabled or not
								if current_admin.gauth_enabled == "1"||current_admin.gauth_enabled=="t"

									respond_to do |format|
										format.html { render @action.template_name }
										format.js   { render @action.template_name, :layout => false }
									end
								else
									flash[:error]= "Please enable the 2FA"
									redirect_to index_path
								end
							else
								flash[:error] = "Super Admin can only delete the rows"
								redirect_to index_path
							end

						elsif request.delete? # DESTROY
							
							if current_admin.role =="Super Admin"
								if current_admin.gauth_enabled == "1"||current_admin.gauth_enabled=="t"
									valid_vals = []
									valid_vals << ROTP::TOTP.new(current_admin.gauth_secret).at(Time.now)
									(1..current_admin.class.ga_timedrift).each do |cc|
										valid_vals << ROTP::TOTP.new(current_admin.gauth_secret).at(Time.now.ago(30*cc))
										valid_vals << ROTP::TOTP.new(current_admin.gauth_secret).at(Time.now.in(30*cc))
									end
									if valid_vals.include?(params[:token].to_i)

											@object.destroy
											flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.delete.done"))
											redirect_to index_path
									else
											flash[:error] = "Incorrect code"
											redirect_to index_path
									end
								else
									flash[:error]= "Please enable the 2FA"
									redirect_to index_path
								end
							else
								flash[:error] = "Super Admin can only delete the rows"
								redirect_to index_path
							end
						end
					end
				end

				register_instance_option :link_icon do
					'icon-remove'
				end
			end
		end
	end
end
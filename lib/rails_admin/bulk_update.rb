module RailsAdmin
  module Config
    module Actions
      class BulkUpdate < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        

        register_instance_option :http_methods do
          [:get,:post]
        end

        register_instance_option :controller do
          proc do
            @bulk_values = list_entries(@model_config)
             if request.params['update_value'].present?
              @bulk_values.update_all(url: params[:update_value])
              redirect_to index_path, flash: {info: "values updated  for #{@bulk_values.count} rows"}
            else
                flash[:alert] = 'No values selected'
                render @action.template_name
            end
          end
        end

        register_instance_option :bulkable? do
          true
        end
      end
    end
  end
end
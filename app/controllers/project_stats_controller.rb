class ProjectStatsController < ApplicationController
	def new
		@project_stat =ProjectStat.new
	end
	def show
		@project=Project.find(params[:id])
		@languages = Language.where(project_id:@project.id)
		@project_stats = ProjectStat.where(project_id: @project.id)

		model_files = "#{Rails.root}/public/#{@project.project_name}/app/models/**/*"
		@models = Dir.glob(model_files).select { |e| File.file? e } 

		controller_files = "#{Rails.root}/public/#{@project.project_name}/app/controllers/**/*"
		@controllers = Dir.glob(controller_files).select { |e| File.file? e }

		view_files = "#{Rails.root}/public/#{@project.project_name}/app/views/**/*"
		@views = Dir.glob(view_files).select { |e| File.file? e }
		respond_to do |format|
		      format.html
		      format.pdf do
		        render pdf: "#{@project.project_name}_stat",template: "project_stats/show.html.erb"   # Excluding ".pdf" extension.
		      end
		    end

	end
end

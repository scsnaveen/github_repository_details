class ProjectStatsController < ApplicationController
	def new
		@project_stat =ProjectStat.new
	end
	def show
		@project=Project.find(params[:id])
		@project_stats = ProjectStat.where(project_id: @project.id)
	end
end

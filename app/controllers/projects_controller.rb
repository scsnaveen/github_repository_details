require 'net/http'
require 'json'
class ProjectsController < ApplicationController
	def new
		@project = Project.new
	end

	def create
	@project = Project.new(project_params)
	# using split for details
	split_url = @project.url.split('/')
	# getting github repository username
	@user_name =split_url[3]
	# getting project name with git extension
	@name = split_url[4]
	# removing git extension
	project_name = @name.split('.')
	@project.project_name = project_name[0]
		# checking if project is present in database
		if !(Project.find_by(project_name:@project.project_name).present?)
			# cloning into public folder 
			system("git clone #{@project.url} #{Rails.root}/public/new/#{@project.project_name}")

			# using github api to get languages
			@url = "https://api.github.com/repos/" +@user_name+"/"+@project.project_name+"/languages"
			# for getting languages as json response
			uri = URI(@url)
			response = Net::HTTP.get(uri)
			values = JSON.parse(response)
			values.each do |n|
				@project.languages << n[0]
			end
			@project.save
			redirect_to projects_show_path(:id=>@project.id)
		else
			@project= Project.find_by(project_name:@project.project_name)
			redirect_to projects_show_path(:id=>@project.id)
		end
	end

	def show
	@project = Project.find(params[:id])

	dir = "public/new/#{@project.project_name}/app/models/**/*.rb"
	@files =	Dir[dir]
	@files.each do |filename|
	   count = IO.readlines(filename).size
	   puts "#{count} lines in #{filename}"
	 end
	@models =	Dir.glob(dir)

	dir = "public/new/#{@project.project_name}/app/controllers/**/*.rb"
	@controllers =	Dir.glob(dir)

	dir = "public/new/#{@project.project_name}/app/views/**/*.erb"
	@views =	Dir.glob(dir)
	end
	def file_details(file)
		

	end

	private
	def project_params
	params.permit(:name,:url,:languages)
	end
end

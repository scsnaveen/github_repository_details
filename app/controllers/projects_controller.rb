class ProjectsController < ApplicationController
	def new
		@project = Project.new
	end

	def create
	@project = Project.new(project_params)
	# using split for details
	split_url = @project.url.split('/')

	# getting project name with git extension
	@name = split_url[4]
	# removing git extension
	project_name = @name.split('.')
	@project.project_name = project_name[0]
		# checking if project is present in database
		if !(Project.find_by(project_name:@project.project_name).present?)
			# cloning into public folder 
			system("git clone #{@project.url} #{Rails.root}/public/#{@project.project_name}")
			# getting project directory
			dir = "#{Rails.root}/public/#{@project.project_name}/**/*"
			# getting all files
			@files =	Dir.glob(dir, File::FNM_DOTMATCH).select { |e| File.file? e }

			# getting model files diectory
			model_files = "#{Rails.root}/public/#{@project.project_name}/app/models/**/*"
			# getting files from a given directory
			model_files_count = Dir.glob(model_files).select { |e| File.file? e }
			# getting model files count 
			@project.models_count = model_files_count.count

			# getting controller files directory
			controller_files = "#{Rails.root}/public/#{@project.project_name}/app/controllers/**/*"
			# getting files from a given directory
			controller_files_count = Dir.glob(controller_files).select { |e| File.file? e }
			# getting controller files count
			@project.controllers_count = controller_files_count.count

			# getting view files directory
			view_files = "#{Rails.root}/public/#{@project.project_name}/app/views/**/*"
			# getting files from a given directory
			view_files_count = Dir.glob(view_files).select { |e| File.file? e }
			# getting views files count
			@project.views_count = view_files_count.count

			@project.save
			split_url = @project.url.split('/')
			# getting github repository username
			@user_name =split_url[3]
			# using github api to get languages
				@url = "https://api.github.com/repos/" +@user_name+"/"+@project.project_name+"/languages"
				# for getting languages as json response
				uri = URI(@url)
				response = Net::HTTP.get(uri)
				values = JSON.parse(response)
				value =[]
				values.each do |n|
					value <<n[0]
					@language = Language.new()
						value.each do |language_value|
						@language.project_id = @project.id
						@language.language =  language_value
					end
					@language.save
				end
			file_details(@files,@project.id)

			redirect_to project_stats_show_path(:id=>@project.id)
		else
			@project= Project.find_by(project_name:@project.project_name)
			redirect_to project_stats_show_path(:id=>@project.id)
		end
	end

	def show
	@project = Project.find(params[:id])

	
		# respond_to do |format|
		# 	format.html
		# 	format.pdf do
		# 		# pdf = ProjectStatPdf.new(@project)
		# 		send_data render pdf:"project id:#{@project.id}",template: "projects/show.html.erb"
		# 		# send_data pdf.render, filename: "hello.pdf",type: "application/pdf",disposition: "inline"
		# 	end
		# end
	end
	def file_details(files,project_id)
		files.each do |filename|
				
				words_count =0
				line_word_count =[]

				letters_count =0
				line_letters_count = []

				spaces_count = 0
				line_spaces_count = []

				file = File.open(filename, "r") { |file| file.each_line { |line|
					# counting words,letters,spaces in each line
					line_word_count << line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').scan(/\w+/).size	
					line_letters_count << line.length
					line_spaces_count << line.count(' ')
				}
				# calculating lines,words and spaces of a file
				@project_stat = ProjectStat.new()
				@project_stat.project_id =project_id
				# number of lines
				@project_stat.lines = IO.readlines(filename).size
				# number of words 
				@project_stat.words =line_word_count.sum
				# number of letters
				@project_stat.letters =line_letters_count.sum
				# number of spaces
				@project_stat.spaces =line_spaces_count.sum
				}
				@project_stat.file_name = filename.split('/',8).last
				@project_stat.save
		end
	end

	private
	def project_params
	params.permit(:name,:url,:models_count,:controllers_count,:views_count)
	end
end

class LanguagesController < ApplicationController
	def new
		@language = Language.new
	end
end

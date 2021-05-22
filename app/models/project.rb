class Project < ApplicationRecord
	has_many :project_stats, dependent: :destroy
	has_many :languages, dependent: :destroy
end

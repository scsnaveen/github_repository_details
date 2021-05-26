class Project < ApplicationRecord
	belongs_to :user
	has_many :project_stats, dependent: :destroy
	has_many :languages, dependent: :destroy
end

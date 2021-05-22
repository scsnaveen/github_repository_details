class AddColsToProjects < ActiveRecord::Migration[6.1]
  def change
  	add_column :projects,:models_count,:integer
  	add_column :projects,:controllers_count,:integer
  	add_column :projects,:views_count,:integer
  	remove_column :projects,:languages,:string,array: true, default: []
  end
end

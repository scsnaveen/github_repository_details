class AddColumnToProjects < ActiveRecord::Migration[6.1]
  def change
  	add_column :projects,:priority,:string
  end
end

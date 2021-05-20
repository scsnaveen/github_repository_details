class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
    	t.string :url
    	t.string :languages,array: true, default: []
    	t.string :project_name

      t.timestamps
    end
  end
end

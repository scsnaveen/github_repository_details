class CreateProjectStats < ActiveRecord::Migration[6.1]
  def change
    create_table :project_stats do |t|
    	t.string :file_name
    	t.integer :lines
    	t.integer :words
    	t.integer :letters
    	t.string :spaces
    	t.references :project,null: false ,foreign_key: true

      t.timestamps
    end
  end
end

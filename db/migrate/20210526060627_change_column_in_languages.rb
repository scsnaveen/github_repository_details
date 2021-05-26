class ChangeColumnInLanguages < ActiveRecord::Migration[6.1]
  def change
  	change_column :languages, :version, :string
  end
end

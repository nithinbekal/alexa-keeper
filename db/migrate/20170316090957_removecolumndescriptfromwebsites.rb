class Removecolumndescriptfromwebsites < ActiveRecord::Migration[5.0]
  def change
     remove_column :websites, :descript
  end
end

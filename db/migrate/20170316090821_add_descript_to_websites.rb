class AddDescriptToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :descript, :string
  end
end

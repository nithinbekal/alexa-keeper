class AddDescriptionToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :description, :string
  end
end

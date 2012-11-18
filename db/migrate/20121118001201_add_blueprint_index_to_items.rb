class AddBlueprintIndexToItems < ActiveRecord::Migration
  def change
    add_column :items, :blueprint_id, :integer
    add_index :items, :blueprint_id
  end
end

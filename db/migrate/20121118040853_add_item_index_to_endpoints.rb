class AddItemIndexToEndpoints < ActiveRecord::Migration
  def change
    add_column :endpoints, :item_id, :integer
    add_index :endpoints, :item_id
  end
end

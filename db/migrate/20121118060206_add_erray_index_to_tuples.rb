class AddErrayIndexToTuples < ActiveRecord::Migration
  def change
    add_column :tuples, :erray_id, :integer
    add_index :tuples, :erray_id
  end
end

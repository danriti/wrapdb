class CreateTuples < ActiveRecord::Migration
  def change
    create_table :tuples do |t|
      t.string :key
      t.references :dictionary
      t.references :item

      t.timestamps
    end
    add_index :tuples, :dictionary_id
    add_index :tuples, :item_id
  end
end

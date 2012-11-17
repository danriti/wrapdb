class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :keytype
      t.string :value
      t.references :dictionary
      t.references :erray

      t.timestamps
    end
    add_index :items, :dictionary_id
    add_index :items, :erray_id
  end
end

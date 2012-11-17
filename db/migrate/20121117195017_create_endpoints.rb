class CreateEndpoints < ActiveRecord::Migration
  def change
    create_table :endpoints do |t|
      t.string :name
      t.references :project
      t.references :dictionary

      t.timestamps
    end
    add_index :endpoints, :project_id
    add_index :endpoints, :dictionary_id
  end
end

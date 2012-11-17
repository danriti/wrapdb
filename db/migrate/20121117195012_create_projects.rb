class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :projects, :user_id
  end
end

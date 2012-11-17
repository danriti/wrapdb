class CreateErrays < ActiveRecord::Migration
  def change
    create_table :errays do |t|

      t.timestamps
    end
  end
end

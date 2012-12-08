class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :description
      t.boolean :done
      t.integer :owner

      t.timestamps
    end
  end
end

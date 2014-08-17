class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.references :render, index: true
      t.string :name
      t.text :query
      t.text :stack_trace
      t.float :duration, default: 0
      t.timestamps
    end
  end
end

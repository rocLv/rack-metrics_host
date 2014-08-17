class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :project, index: true
      t.string :env
      t.string :name
      t.string :controller
      t.string :action
      t.string :method
      t.string :format
      t.text :path
      t.datetime :started
      t.integer :status
      t.float :duration, default: 0
      t.float :view_runtime, default: 0
      t.float :db_runtime, default: 0
      t.float :memory, default: 0
      t.timestamps
    end
    add_index :requests, :env
    add_index :requests, :started
    add_index :requests, :status
    add_index :requests, :duration
  end
end

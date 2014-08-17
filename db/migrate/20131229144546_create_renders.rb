class CreateRenders < ActiveRecord::Migration
  def change
    create_table :renders do |t|
      t.references :request, index: true
      t.string :layout
      t.string :view
      t.float :duration, default: 0
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
    add_index :renders, :parent_id
    add_index :renders, :lft
    add_index :renders, :rgt
    add_index :renders, :depth
  end
end

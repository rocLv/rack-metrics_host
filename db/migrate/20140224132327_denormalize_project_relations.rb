class DenormalizeProjectRelations < ActiveRecord::Migration
  def change
    add_column :renders, :project_id, :integer
    add_column :queries, :project_id, :integer
    add_index :renders, :project_id
    add_index :queries, :project_id
  end
end

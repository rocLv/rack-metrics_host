class CreateApiRequest < ActiveRecord::Migration
  def change
    create_table :api_requests do |t|
      t.integer :project_id
      t.string :api_version
      t.text :data
    end
  end
end

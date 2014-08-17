class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.belongs_to :project, index: true
      t.boolean :active
      t.integer :response_time_treshold

      t.timestamps
    end
  end
end

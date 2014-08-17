class AddIndexToRequestsName < ActiveRecord::Migration
  def change
    add_index :requests, :name
  end
end

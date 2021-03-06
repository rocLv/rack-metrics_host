class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end

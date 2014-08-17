class Project < ActiveRecord::Base
  has_many :requests
  has_many :invitations
  has_many :alerts, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_and_belongs_to_many :users
  after_create -> { self.users<<(self.owner) }
  after_create :reset_api_key

  def reset_api_key
    update_attribute :api_key, SecureRandom.hex if api_key.blank?
  end

  def storage_size
    size = 0
    %w{requests renders queries}.each do |table|
      size =+ ActiveRecord::Base.connection.execute("SELECT sum(pg_column_size(#{table})) FROM #{table} where project_id = #{self.id};")[0]["sum"].to_i
    end
    size
  end

  def requests_today
    requests.where('started > ?', DateTime.now.beginning_of_day).count
  end
end

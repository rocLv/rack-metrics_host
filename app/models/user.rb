class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  has_many :owned_projects, class_name: 'Project', foreign_key: :owner_id
  has_and_belongs_to_many :projects
  validates_presence_of :name
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map.keys
end

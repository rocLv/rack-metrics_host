class Render < ActiveRecord::Base
  belongs_to :request
  has_many :queries, dependent: :destroy
  acts_as_nested_set
end

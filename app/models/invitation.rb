class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  validate :email_cannot_be_owners
  before_save :generate_token
  before_save :set_user_id
  validate :email_cannot_be_owners

  def email_cannot_be_owners
    errors.add(:email, "can't be yours") if self.email == self.project.owner.email
  end

  def set_user_id
    user = User.where(email: email).first
    self.user_id = user.id unless user.nil?
  end

  def generate_token
    self.token = SecureRandom.hex
  end
end

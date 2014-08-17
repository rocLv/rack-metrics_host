class Request < ActiveRecord::Base
  belongs_to :project
  has_many :renders, dependent: :destroy
  has_many :queries, through: :renders

  scope :group_by, ->(s) {
    group("round(extract(epoch from \"started\"::timestamptz AT TIME ZONE 'Etc/UTC')/#{s})")
  }

  after_create :notify

  def notify
    alert = project.alerts.where('active = true and response_time_treshold <= ?', duration).first
    logger.debug alert
    AlertMailer.notify(self) unless alert.nil?
  end
end
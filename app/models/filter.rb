class Filter
  include ActiveModel::Model
  attr_accessor :from, :to, :env

  def initialize(attributes={})
    super
    @from ||= 1.hour.ago.strftime "%Y-%m-%d %H:%M"
    @to ||= Time.current.strftime "%Y-%m-%d %H:%M"
    @env ||= 'production'
  end

  def from_time
    Time.zone.parse(@from) if @from.is_a?(String)
  end

  def to_time
    Time.zone.parse(@to) if @to.is_a?(String)
  end
end

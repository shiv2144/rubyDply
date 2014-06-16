class Job < ActiveRecord::Base
  extend Enumerize

  enumerize :status, in: [:pending, :in_progress, :completed], default: :pending

  # Associations
  belongs_to :company
  belongs_to :lead
  belongs_to :account
  belongs_to :trade
  belongs_to :job_type
  belongs_to :address
  has_many :appointments

  # Validations
  validates :account, presence: true
  validates :trade, presence: true

  # Scopes
  default_scope -> { order('created_at DESC') }

  # Calbacks
  before_validation :set_trade

  # def description
  #   self[:description] || (self.job_type.nil?) ? nil :  self.job_type.description
  # end

  # Returns true if this job is a lead
  def is_lead?
    self.lead_id.nil? == false
  end

  # Returns true if lead has not been approved by champ user
  def is_unapproved_lead?
    self.lead.approved_at.nil?
  end

  # Returns next appointment record
  def next_appointment
    self.appointments.first
  end


private

  # Set trade_id from job type
  def set_trade
    if self.trade_id.nil? && !self.job_type.nil?
      self.trade_id = self.job_type.trade_id
    end
  end
end

class Lead < ActiveRecord::Base

  # Associations
  belongs_to :company
  belongs_to :user
  belongs_to :trade
  belongs_to :address
  has_one :job

  # Validations
  validates :company, presence: true
  validates :user, presence: true
  validates :trade, presence: true

  # Callbacks
  before_validation :set_expires_at

  # Scopes
  default_scope -> { order('created_at DESC') }
  scope :active, -> { where("expires_at > '#{Time.now.to_s(:db)}' AND accepted_at IS NULL AND rejected_at IS NULL") }
  scope :expired, -> { where("expires_at <= '#{Time.now.to_s(:db)}' AND accepted_at IS NULL AND rejected_at IS NULL") }
  scope :accepted, -> { where("accepted_at IS NOT NULL") }
  scope :rejected, -> { where("rejected_at IS NOT NULL") }
  scope :approved, -> { where("approved_at IS NOT NULL") }

  # Delegates
  delegate :name, to: :user

  # Returns true if lead has expired
  def expired?
    self.expired_at <= Time.now.utc
  end

  # Returns true if lead was accepted
  def accepted?
    !self.accepted_at.nil?
  end

  # Returns true if lead was rejected
  def rejected?
    !self.rejected_at.nil?
  end

  # Returns true if lead has been approved by customer
  def aquired?
    !self.approved_at.nil?
  end

private

  def set_expires_at
    if self[:expires_at].nil?
      self[:expires_at] = 30.minutes.from_now.utc
    end
  end

end

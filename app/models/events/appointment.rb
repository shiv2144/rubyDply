class Appointment < Event

  # Validations
  validates :job, presence: true
  validates :account, presence: true
  validates :member, presence: true

end

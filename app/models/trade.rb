class Trade < ActiveRecord::Base
  DEFAULT_TRADE_NAMES = [ 'plumber','carpenter','electrician','roofer' ]

  # Associations
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :members
  has_many :job_types

  scope :default, -> { where(name: DEFAULT_TRADE_NAMES) }
  scope :active, -> { all } # All for now..


end

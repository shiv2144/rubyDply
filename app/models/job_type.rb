class JobType < ActiveRecord::Base

  # Associations
  belongs_to :company
  belongs_to :trade
  has_many :jobs

  # Scopes
  scope :defaults, -> { where("company_id IS NULL") }


end

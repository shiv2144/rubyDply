class Trade < ActiveRecord::Base

  # Associations
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :members
  has_many :job_types

end
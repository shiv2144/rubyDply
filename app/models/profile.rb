class Profile < ActiveRecord::Base

  # Associations
  belongs_to :member

  # Nested attributes
  accepts_nested_attributes_for :member

  # Validations
  validates_associated :member

end

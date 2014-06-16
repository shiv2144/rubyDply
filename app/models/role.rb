class Role < ActiveRecord::Base

  # Relations
  has_and_belongs_to_many :members, join_table: :members_roles
  belongs_to :resource, polymorphic: true

  # Pulgin
  scopify


private

end

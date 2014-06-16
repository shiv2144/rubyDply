class Member < ActiveRecord::Base
  include Addressable
  include Contactable

  # Associations
  belongs_to :company
  belongs_to :primary_address, class_name:'Address'
  belongs_to :primary_email, class_name:'Contact'
  belongs_to :primary_phone, class_name:'Contact'
  has_and_belongs_to_many :trades
  has_and_belongs_to_many :roles, join_table: :members_roles
  has_one :profile
  has_many :jobs
  has_many :events
  has_many :appointments

  # Nested attributes
  accepts_nested_attributes_for :company
  accepts_nested_attributes_for :primary_address, reject_if: :all_blank
  accepts_nested_attributes_for :primary_email, reject_if: :all_blank
  accepts_nested_attributes_for :primary_phone, reject_if: :all_blank

  # Validations
  validates :company, presence: true
  validates_associated :company
  validates_associated :primary_address
  validates_associated :primary_email
  validates_associated :primary_phone

  # Callbacks
  after_create :create_profile
  after_create :set_owner_and_roles


  # First and last name
  def full_name
    [self.first_name, self.last_name].compact.join(" ").strip
  end
  alias_method :name, :full_name

  # Devise override
  def password_required?
    false
  end

private

  # Creates a default (empty) profile
  def create_profile
    Profile.create!(member_id:self.id) if self.profile.nil?
  end

  # Creates default roles for owner
  def set_owner_and_roles
    if Member.where(company_id: self.company_id).count == 1
      self.add_role :director
      self.add_role :manager
      self.add_role :tradesman
      self.company.update(owner_id:self.id)
    end
  end
end

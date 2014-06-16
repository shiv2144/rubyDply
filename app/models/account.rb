class Account < ActiveRecord::Base
  include Addressable
  include Contactable

  # Associations
  belongs_to :company
  belongs_to :user
  belongs_to :primary_address, class_name:'Address'
  belongs_to :primary_email, class_name:'Contact'
  belongs_to :primary_phone, class_name:'Contact'
  has_many :jobs

  # Nested attributes
  accepts_nested_attributes_for :primary_address
  accepts_nested_attributes_for :primary_email
  accepts_nested_attributes_for :primary_phone #, reject_if: :all_blank

  # Validations
  validates :company, presence: true
  validates :first_name, presence: true, if: Proc.new { |a| a.user_id.nil? }
  validates :last_name, presence: true, if: Proc.new { |a| a.user_id.nil? }
  validates_associated :primary_address, if: Proc.new { |a| a.user_id.nil? }
  validates_associated :primary_email, if: Proc.new { |a| a.user_id.nil? }
  validates_associated :primary_phone, if: Proc.new { |a| a.user_id.nil? }

  # Scopes
  scope :search, lambda { |term|
    if !term.blank?
      where("first_name like '#{term}%' OR last_name like '#{term}%'")
    end
  }

  # Callbacks
  after_create :fix_polymorphic_types

  # First and last name
  def full_name
    if self.user_id.nil?
      [self.first_name, self.last_name].compact.join(" ").strip
    else
      # "#{self.user.name} [Champ Lead]"
      self.user.name
    end
  end
  alias_method :name, :full_name

  # Returns true if this account can be managed. Accounts that
  # are created by a company (by a manager) will have contact info.
  # Accounts that came from champ leads will not have contact info
  # as the contact/address info is managed by the champ user.
  def is_manageable?
    self.contacts.count > 0
  end

  # Returns true customer is registered with champ
  def is_champ_user?
    !self.user_id.nil?
  end


private

  # Workaround for belongs_to polymorphic bug in nested forms
  def fix_polymorphic_types
    if !self.primary_address_id.nil?
      pa=Address.find(self.primary_address_id)
      pa.update(addressable_id: self.id, addressable_type: 'Account')
    end
    if !self.primary_email_id.nil?
      pce=Contact.find(self.primary_email_id)
      pce.update(contactable_id: self.id, contactable_type: 'Account')
    end
    if !self.primary_phone_id.nil?
      pcp=Contact.find(self.primary_phone_id)
      pcp.update(contactable_id: self.id, contactable_type: 'Account')
    end
  end
end

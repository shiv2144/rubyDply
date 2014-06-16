class Contact < ActiveRecord::Base

  # Associations
  belongs_to :contactable, polymorphic: true

  # Validations
  validates :type, presence: true
  validates :subtype, presence: true
  validates :info, presence: true,
    uniqueness: {scope: [:contactable_id,:contactable_type], case_sensitive: false}

  # Callbacks
  after_create :set_primary

  # Turn off STI
  self.inheritance_column = :_type_disabled


  # Returns contact label based on type
  def label
    if self.type == 'phone'
      'Phone Number'
    else
      'Email Address'
    end
  end

  # Returns human friendly type label
  def type_label
    self.type.to_s.humanize.capitalize
  end

  # Returns human friendly subtype lable
  def subtype_label
    self.subtype.to_s.humanize.capitalize
  end

  TYPE_OPTIONS = {
    phone: [:home,:fax,:mobile,:main,:home_fax,:work_fax,:pager,:other],
    email: [:home,:work,:other]
    # url: [:home_page,:home,:work,:other,:custom_label],
    # instant_message: [:skype,:msn_messenger,:google_talk,:facebook_messenger,:aim,:yahoo_messenger,:icq,:jabber],
    # social_profile: [:twitter,:facebook,:flickr,:linkedin,:myspace,:custom_label]
  }

private

  # Sets primary attribute automagically if first contact record
  def set_primary
    if contactable.reload.contacts.count < 2
      self.primary = true
      save!
    end
  end
  def set_primary
    if self.type == 'phone'
      if contactable.respond_to?("primary_phone_id=") &&
          contactable.reload.primary_phone_id.nil?
        contactable.update(primary_phone_id:self.id)
      end
    elsif self.type == 'email'
      if contactable.respond_to?("primary_email_id=") &&
          contactable.reload.primary_email_id.nil?
        contactable.update(primary_email_id:self.id)
      end
    end
  end

end

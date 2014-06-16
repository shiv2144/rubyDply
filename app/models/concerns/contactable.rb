module Contactable

  def self.included(clazz)
    clazz.class_eval do
      has_many :contacts, as: :contactable
    end
  end

  # def primary_contact
  #   contacts.where(primary: true).first
  # end
  #
  # def primary_phone
  #   contacts.where(type: 'phone', primary: true).first
  # end
  #
  # def primary_email
  #   contacts.where(type: 'email', primary: true).first
  # end

end

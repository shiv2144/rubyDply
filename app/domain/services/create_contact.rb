class CreateContact
  include Wisper::Publisher

  def execute(performer, contactable, attributes)
    contact = contactable.contacts.new(attributes)
    if contact.save
      broadcast(:create_contact_successful, performer, contact)
    else
      broadcast(:create_contact_failed, performer, contact)
    end
  end
end

class UpdateContact
  include Wisper::Publisher

  def execute(performer, contact, attributes)
    if contact.update(attributes)
      broadcast(:update_contact_successful, performer, contact)
    else
      broadcast(:update_contact_failed, performer, contact)
    end
  end
end

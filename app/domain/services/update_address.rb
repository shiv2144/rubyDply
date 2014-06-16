class UpdateAddress
  include Wisper::Publisher

  def execute(performer, address, attributes)
    if address.update(attributes)
      broadcast(:update_address_successful, performer, address)
    else
      broadcast(:update_address_failed, performer, address)
    end
  end
end

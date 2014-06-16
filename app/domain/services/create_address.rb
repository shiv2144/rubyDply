class CreateAddress
  include Wisper::Publisher

  def execute(performer, addressable, attributes)
    address = addressable.addresses.new(attributes)
    if address.save
      broadcast(:create_address_successful, performer, address)
    else
      broadcast(:create_address_failed, performer, address)
    end
  end
end

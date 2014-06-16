class CreateDemoAccount
  include Wisper::Publisher

  def execute(performer)
    account = performer.company.accounts.new(fake_attributes)
    if account.save
      account.addresses.create!(fake_address_attributes)
      account.contacts.create!(fake_phone_attributes)
      account.contacts.create!(fake_email_attributes)
      broadcast(:create_demo_customer_successful, performer, account)
    else
      broadcast(:create_demo_customer_failed, performer, account)
    end
  end

private

  def fake_attributes
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.first_name,
    }
  end
  # email: Faker::Internet.email
  # }

  def fake_address_attributes
    Address::LD_ADDRESSES.sample
    # {
    #   address_line_1: Faker::Address.street_address,
    #   city: Faker::Address.city,
    #   region: Faker::Address.state,
    #   country: Faker::Address.country,
    #   postcode: Faker::Address.postcode,
    #   latitude: Faker::Address.latitude,
    #   longitude: Faker::Address.longitude
    # }
  end

  def fake_phone_attributes
    {
      type: 'phone',
      subtype: 'home',
      info: Faker::PhoneNumber.cell_phone
    }
  end

  def fake_email_attributes
    {
      type: 'email',
      subtype: 'home',
      info: Faker::Internet.email
    }
  end
end

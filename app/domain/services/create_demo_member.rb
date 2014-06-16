class CreateDemoMember
  include Wisper::Publisher

  def execute(performer)
    member = performer.company.members.new(fake_attributes)
    if member.save
      member.addresses.create!(fake_address_attributes)
      member.contacts.create!(fake_phone_attributes)
      member.contacts.create!(fake_email_attributes)
      broadcast(:create_demo_member_successful, performer, member)
    else
      broadcast(:create_demo_member_failed, performer, member)
    end
  end

private

  def fake_attributes
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.first_name,
      email: Faker::Internet.email,
      role_ids: [Role.find_by_name('tradesman').id]
    }
  end

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
      subtype: 'work',
      info: Faker::PhoneNumber.cell_phone
    }
  end

  def fake_email_attributes
    {
      type: 'email',
      subtype: 'work',
      info: Faker::Internet.email
    }
  end

end

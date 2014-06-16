class CreateDemoLead
  include Wisper::Publisher

  def execute(performer)
    user = User.new(fake_attributes)
    if user.save
      user.addresses.create!(fake_address_attributes)
      user.contacts.create!(fake_phone_attributes)
      user.contacts.create!(fake_email_attributes)
      user.reload
      lead = Lead.create!(fake_lead_attributes(performer, user))
      broadcast(:create_user_successful, performer, user)
    else
      broadcast(:create_user_failed, performer, user)
    end
  end

private

  def fake_attributes
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.first_name,
      email: Faker::Internet.email
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

  def fake_lead_attributes(performer, user)
    trades = performer.company.trades
    trade = (trades.empty?) ? Trade.find_by_name('plumber') : trades.sample
    job_types = JobType.where(trade_id:trade.id)
    job_type = job_types.sample
    {
      company_id: performer.company_id,
      user_id: user.id,
      trade_id: trade.id,
      address_id: user.primary_address_id,
      # job_type_id: job_type.id,
      job_description: Faker::Lorem.paragraph
    }
  end
end

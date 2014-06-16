class Address < ActiveRecord::Base

  # Atrr Aliases
  alias_attribute :lat, :latitude
  alias_attribute :lng, :longitude

  # Associations
  belongs_to :addressable, polymorphic: true

  # Validations
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :country, presence: true
  validates :postcode, presence: true

  # Geocoding
  geocoded_by :full_address

  # Callbacks
  after_validation :geocode,
    if: Proc.new { |a| a.latitude.blank? } # auto-fetch coordinates
  after_create :set_primary


  # full address for geocoding lookups
  def full_address
    [address_line_1, city, region, country].compact.join(', ')
  end

  # Returns string consisting of city,region & postcode
  def city_region_postcode
    "#{self.city}, #{self.region} #{self.postcode}"
  end

private

  # Sets primary address automagically for addressable
  def set_primary
    if addressable.respond_to?("primary_address_id=") &&
        addressable.reload.primary_address_id.nil?
      addressable.update(primary_address_id:self.id)
    end
  end

  # Dummy address for demo / testing
  LD_ADDRESSES = [
    { address_line_1: '1650 Davie St',
      city: 'Vancouver',
      region: 'BC',
      country: 'Canada',
      postcode: 'V6G 1V9' },
    { address_line_1: '10355 152 St #2300',
      city: 'Surry',
      region: 'BC',
      country: 'Canada',
      postcode: 'V3R 7C1' },
    { address_line_1: '5639 Victoria Drive',
      city: 'Vancouver',
      region: 'BC',
      country: 'Canada',
      postcode: 'V5P 3W2' },
    { address_line_1: '20202 66 Ave',
      city: 'Langely',
      region: 'BC',
      country: 'Canada',
      postcode: 'V2Y 1P3' },
    { address_line_1: '3122 Mt Lehman Rd',
      city: 'Abbotsford',
      region: 'BC',
      country: 'Canada',
      postcode: 'V2T 0C5' },
  ]
end

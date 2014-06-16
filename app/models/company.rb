class Company < ActiveRecord::Base
  include Addressable
  include Contactable

  # Associations
  has_many :members
  has_many :accounts
  has_many :leads
  has_many :jobs
  has_many :events
  has_many :job_types
  has_and_belongs_to_many :trades
  belongs_to :owner, class_name: 'Member'
  belongs_to :trade

  # Validations
  validates :name, presence: true
  # validates :trades, presence: true

  # Callbacks
  after_create :create_default_job_types
  after_create :create_habtm_trade

  # Scopes
  # default_scope -> { order('created_at DESC') }


private

  # Creates default job types based on trade
  def create_default_job_types
    self.trade.job_types.defaults.each do |job_type|
      company_job_type = job_type.attributes.except('id')
      company_job_type['company_id'] = self.id
      logger.info company_job_type.inspect
      JobType.create!(company_job_type)
    end
  end

  # Creates habtm trade entry based on trade_id
  # NOTE: We will support multiple trades later..
  def create_habtm_trade
    self.trades << self.trade
  end

end

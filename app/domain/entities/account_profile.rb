class AccountProfile
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :account

  delegate  :first_name, :first_name=, :last_name, :last_name=,
            :password_confirmation=, :persisted?, :id, :to => :user,
            :prefix => false, :allow_nil => false

  def initialize(user, address, contact_email, contact_phone)
    @user = user
    @email = email
  end

  def email
    @email.address
  end

  def email=(email_addr)
    @email.address = email_addr
  end

  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }
  end

  def save!
    User.transaction do
      @account.save!
      @address.save!
    end
  end

end

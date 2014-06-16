class User < ActiveRecord::Base
  include Addressable
  include Contactable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :accounts
  has_many :companies, through: :accounts
  has_many :jobs

  # Validations
  validates :email, presence: true, uniqueness: true


  # First and last name
  def full_name
    [self.first_name, self.last_name].compact.join(" ").strip
  end
  alias_method :name, :full_name

end

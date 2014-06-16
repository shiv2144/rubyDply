module Addressable

  def self.included(clazz)
    clazz.class_eval do
      has_many :addresses, as: :addressable
    end
  end

  # def primary_address
  #   addresses.where(primary: true).first
  # end

end

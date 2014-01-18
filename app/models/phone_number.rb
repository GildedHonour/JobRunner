class PhoneNumber
  extend Enumerize

  attr_accessor :value
  enumerize :type, in: %i(office residence)
end
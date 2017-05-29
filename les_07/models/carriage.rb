class Carriage
  include Vendor
  include IsValid
  
  attr_reader :type, :capacity
end
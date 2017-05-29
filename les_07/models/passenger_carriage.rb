require_relative 'carriage.rb'

class PassengerCarriage < Carriage 
  def initialize(capacity)
    @type = :passenger
    @capacity = capacity.to_i
    @taken = 0
  end

  def available
    @capacity - self.taken
  end

  def take_the_seat
    self.available.positive? ? @taken += 1 : ( raise 'Свободных мест нет.' )
  end

  def taken
    @taken
  end
end

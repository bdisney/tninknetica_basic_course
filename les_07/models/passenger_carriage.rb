require_relative 'carriage.rb'

class PassengerCarriage < Carriage 
  def initialize(seats)
    @type = :passenger
    @seats = seats.to_i
    @taken = 0
  end

  def available
    @seats - self.taken
  end

  def take_the_seat
    self.available.positive? ? @taken += 1 : ( raise 'Свободных мест нет.' )
  end

  def taken
    @taken
  end
end

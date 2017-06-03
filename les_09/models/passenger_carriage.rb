require_relative 'carriage.rb'

class PassengerCarriage < Carriage
  attr_reader :taken

  def initialize(capacity)
    @type = :passenger
    @capacity = capacity.to_i
    @taken = 0
  end

  def available
    @capacity - @taken
  end

  def take_the_seat
    available.positive? ? @taken += 1 : (raise 'Свободных мест нет.')
  end
end

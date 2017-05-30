require_relative 'carriage.rb'

class CargoCarriage < Carriage
  attr_reader :used_volume

  def initialize(capacity)
    @type = :cargo
    @capacity = capacity.to_f
    @used_volume = 0
  end

  def available
    @capacity - @used_volume
  end

  def fill_in(volume)
    available >= volume ? @used_volume += volume : (raise 'Недостаточно свободного места')
  end
end

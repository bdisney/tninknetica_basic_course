require_relative 'carriage.rb'

class CargoCarriage < Carriage 
  def initialize(capacity)
    @type = :cargo
    @capacity = capacity.to_f
    @used_volume = 0
  end

  def available
    @capacity - self.used
  end

  def fill_in(volume)
    self.available > volume ? @used_volume += volume : ( raise 'Недостаточно свободного места' )
  end

  def used
    @used_volume
  end
end

require_relative 'carriage.rb'

class CargoCarriage < Carriage 
  def initialize(volume)
    @type = :cargo
    @volume = volume
    @used_volume = 0
  end

  def available
    @volume - self.used
  end

  def fill_in(volume)
    self.available > volume ? @used_volume += volume : ( raise 'Недостаточно свободного места' )
  end

  def used
    @used_volume
  end
end

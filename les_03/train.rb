class Train
  TYPE = {passenger: 'Пассажирские', cargo: 'Грузовые'}

  attr_accessor :speed, :carriages_qty, :route
  attr_reader :type

  def initialize(number, type, carriages_qty)
    @number = number
    @type = type
    @carriages_qty = carriages_qty
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_carriage
    if speed == 0 
      self.carriages_qty += 1 
    else
      puts 'Прежде чем добавить вагон остановите поезд.'
    end
  end

  def unhook_carriage
    if speed == 0 && carriages_qty > 0
      self.carriages_qty -= 1 
    else
      puts 'Прежде чем отцепить вагон остановите поезд.' if speed > 0
      puts "Нечего отцеплять. Кол-во вагонов: #{carriages_qty}" if carriages_qty == 0
    end
  end

  def set_route(route)
    self.route = route
    #current_station = route.stations.first
  end

  def increase_speed(value)
    self.speed = value
  end

  def current_speed
    self.speed
  end

  def current_carriages_qty
    self.carriages_qty
  end

  def about
    puts "Тип: #{TYPE[self.type]}, вагонов: #{self.carriages_qty}, скорость: #{self.speed}"
  end

  # def current_station
  #   self.current_station
  # end
end
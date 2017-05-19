class Train
  TYPE = {passenger: 'Passenger', cargo: 'Cargo'}

  attr_accessor :speed, :carriages_qty, :route
  attr_reader :type, :route, :current_station, :number

  def initialize(number, type, carriages_qty)
    @number = number
    @type = type
    @carriages_qty = carriages_qty
    @speed = 0
  end
 
  #Блок по управлению движением
  def increase_speed(value)
    self.speed = value
  end

  def current_speed
    self.speed
  end

  def stop
    self.speed = 0
  end

  #Добавление/отцепка вагонов
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

  #Присваивание маршрута
  def set_route(route)
    @route = route
    puts "Назначен маршрут: #{route.stations.first} - #{route.stations.last}"

    self.current_station = route.stations.first
    puts "Текущая станция: #{current_station}"
  end

  #Перемещение по маршруту
  def move(direction)
    if self.route 
      if direction == :forward && self.next_station
        self.increase_speed(20)
        puts "Вжжжжж..."

        self.current_station = self.next_station
        self.stop

        puts "Поезд прибыл на станцию: #{current_station}"
      elsif direction == :back && self.prev_station
        self.increase_speed(20)
        puts "Вжжжжж..."

        self.current_station = self.prev_station
        self.stop

        puts "Поезд прибыл на станцию: #{current_station}"
      else
        puts "...движение невозможно"
      end
    else
      puts "Прежде чем начать движение необходимо назначить маршрут."
    end
  end


  #Вспомогательные методы пока не прятал их в private
  def current_station=(station)
    @current_station = station
  end

  def next_station
    position = self.route.stations.index(self.current_station)

    if self.current_station == self.route.stations.last
      puts 'Конечная'
    else
      self.route.stations[position + 1] 
    end
  end

  def prev_station
    position = self.route.stations.index(self.current_station)
  
    if self.current_station == self.route.stations.first
      puts 'Конечная'
    else
      self.route.stations[position - 1] 
    end
  end

  def about
    puts "Тип: #{TYPE[self.type]}, вагонов: #{self.carriages_qty}, скорость: #{self.speed}"
  end
end
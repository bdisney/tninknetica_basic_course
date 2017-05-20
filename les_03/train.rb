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
 
  #Блок по управлению скоростью
  def increase_speed(value)
    value.positive? ? self.speed = value : (puts 'Некорректное значение для увеличения скорости.')
  end

  def current_speed
    self.speed
  end

  def stop
    self.speed = 0
  end

  #Добавление/отцепка вагонов
  def add_carriage
    speed.zero? ? self.carriages_qty += 1 : ( puts 'Прежде чем добавить вагон остановите поезд.' )
  end

  def unhook_carriage
    if speed.zero? && carriages_qty.positive?
      self.carriages_qty -= 1 
    else
      puts 'Прежде чем отцепить вагон остановите поезд.' if speed.positive?
      puts "Нечего отцеплять. Кол-во вагонов: #{carriages_qty}" if carriages_qty.zero?
    end
  end

  #Присваивание маршрута
  def set_route(route)
    self.current_station.send_train(self) if self.current_station
    @route = route
    puts "Назначен маршрут: #{route.stations.first.title} - #{route.stations.last.title}"

    self.current_station = route.stations.first
    puts "Текущая станция: #{current_station.title}"
  end

  #Перемещение по маршруту
  def move(direction = :forward || :back)
    if self.route
      sequent_station = (direction == :back ? prev_station : next_station)
      sequent_station ? move_to(sequent_station) : (puts 'Движение в выбранном направлении невозможно.')
    else 
      puts 'Прежде чем начать движение необходимо назначить маршрут.'
    end
  end

  #Вспомогательные методы 
  def current_station=(station)
    self.stop
    station.take_the_train(self)
    @current_station = station
  end

  def next_station
    position = self.route.stations.index(self.current_station)

    self.current_station == self.route.stations.last ? ( puts 'Конечная' ) : self.route.stations[position + 1] 
  end

  def prev_station
    position = self.route.stations.index(self.current_station)
  
    self.current_station == self.route.stations.first ? ( puts 'Конечная' ) : self.route.stations[position - 1]
  end

  def about
    puts "Тип: #{TYPE[self.type]}, вагонов: #{self.carriages_qty}, скорость: #{self.speed}"
  end

  private

  def move_to(sequent_station)
    self.current_station.send_train(self)
    self.current_station = sequent_station
  end
end
class Train
  TYPE = {passenger: 'Пассажирский', cargo: 'Грузовой'}
  INITIAL_SPEED = 0

  attr_reader :type, :route, :current_station, :number, :speed, :carriages

  def initialize(number)
    @number = number
    @carriages = []
    @speed = INITIAL_SPEED
  end

  #Скрытие деталей реализации. Вызов осуществляется только из метода add_carriage после прохождения необходимых проверок
  def add_carriage(carriage)
    self.carriages.push(carriage) if speed.zero?
  end

  def unhook_carriage
    speed.zero? ? unhook_carriage! : (puts 'Прежде чем отцепить вагон остановите поезд.') 
  end

  #Присвоение маршрута
  def set_route(route)
    self.current_station.send_train(self) if self.current_station
    @route = route
    puts "Назначен маршрут: #{route.stations.first.title} - #{route.stations.last.title}"

    self.current_station = route.stations.first
    puts "Текущая станция: #{current_station.title}"
    gets
  end

  #Перемещение по маршруту
  def move(direction = :forward)
    if route
      sequent_station = (direction == :back ? prev_station : next_station)
      sequent_station ? move_to(sequent_station) : (puts 'Движение в выбранном направлении невозможно.')
    else 
      puts 'Прежде чем начать движение необходимо назначить маршрут.'
    end
  end

  #Инфо-методы
  def current_speed
    self.speed
  end

  def next_station
    position = self.route.stations.index(current_station)

    self.current_station == self.route.stations.last ? ( puts 'Конечная' ) : self.route.stations[position + 1] 
  end

  def prev_station
    position = self.route.stations.index(current_station)
  
    current_station == self.route.stations.first ? ( puts 'Конечная' ) : self.route.stations[position - 1]
  end

  def about
    puts "Тип: #{TYPE[self.type]}, вагонов: #{self.carriages_qty}, скорость: #{self.speed}"
  end

  protected

  #Вызов метода должен осуществляться только из метода move и невозможен из вне
  def move_to(sequent_station)
    increase_speed(5)
    self.current_station.send_train(self)
    increase_speed(55)
    self.current_station = sequent_station
    stop
  end

  #Управление скоростью возможно при перемещении между станциями в рамках маршрута и...
  #...в текущей реализации, только из метода move_to 
  def increase_speed(value)
    value.positive? ? @speed = value : (puts 'Некорректное значение для увеличения скорости.')
  end

  #см. комментарий выше
  def stop
    @speed = 0
  end

  #Текущая станция назначается только при присвоении маршрута и изменяется при перемещении между станциями маршрута.
  def current_station=(station)
    stop
    station.take_the_train(self)
    @current_station = station
  end

  #Скрытие деталей реализации. Вызов осуществляется только из метода unhook_carriage после прохождения необходимых проверок
  def unhook_carriage!
    if self.carriages.count.positive? 
      self.carriages.pop
      puts 'Вагон отцеплен'
    else
      puts "Нечего отцеплять. Кол-во вагонов: #{self.carriages.count}" 
    end
  end
end
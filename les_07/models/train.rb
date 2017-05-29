class Train
  include Vendor
  include InstanceCounter
  include IsValid
  
  TYPE = {passenger: 'Пассажирский', cargo: 'Грузовой'}
  INITIAL_SPEED = 0
  NUMBER_FORMAT = /^[a-z0-9]{3}[-]?[a-z0-9]{2}$/i

  @@trains = {}

  attr_reader :type, :route, :current_station, :number, :speed, :carriages

  def initialize(number)
    @number = number
    validate!
    @carriages = []
    @speed = INITIAL_SPEED
    @@trains[number] = self
    register_instance
  end

  def each_carriage(&block)
    self.carriages.each.with_index(1) { |carriage, index| block.call(carriage, index) }
  end

  def valid?
    validate!
  rescue
    false
  end

  def self.all
    @@trains
  end

  def self.find_by(number)
    @@trains[number]
  end

  def add_carriage!(carriage)
    self.type.eql?(carriage.type) ? ( self.carriages << carriage if speed.zero? ) : ( raise 'Тип поезда и вагона не соответствуют.' )
  end

  def unhook_carriage
    speed.zero? ? unhook_carriage! : (raise 'Прежде чем отцепить вагон остановите поезд.') 
  end

  def set_route(route)
    self.current_station.send_train(self) if self.current_station
    @route = route

    self.current_station = route.stations.first
  end

  def move(destination)
    if destination 
      increase_speed(5)
      self.current_station.send_train(self)

      increase_speed(55)
      self.current_station = destination 
    else 
      (raise 'Движение в выбранном направлении невозможно.')
    end
  end

  def next_station
    position = self.route.stations.index(current_station)

    current_station == self.route.stations.last ? ( puts 'Конечная' ) : self.route.stations[position + 1] 
  end

  def prev_station
    position = self.route.stations.index(current_station)
  
    current_station == self.route.stations.first ? ( puts 'Конечная' ) : self.route.stations[position - 1]
  end

  protected

  def validate!
    raise 'Недопустимый формат номера.' if self.number !~ NUMBER_FORMAT
    raise "Поезд с номером #{number} уже существует." if @@trains.has_key?(number)
    true
  end

  def increase_speed(value)
    value.positive? ? @speed = value : ( raise 'Некорректное значение для увеличения скорости.')
  end

  def stop
    @speed = 0
  end

  def current_station=(station)
    stop
    station.take_the_train(self)
    @current_station = station
  end

  def unhook_carriage!
    self.carriages.count.positive? ? self.carriages.pop : ( raise "Нечего отцеплять. Кол-во вагонов: #{self.carriages.count}" )
  end

  def current_speed
    self.speed
  end
end
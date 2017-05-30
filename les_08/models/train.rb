class Train
  include Vendor
  include InstanceCounter
  include IsValid

  TYPE = { passenger: 'Пассажирский', cargo: 'Грузовой' }.freeze
  INITIAL_SPEED = 0
  NUMBER_FORMAT = /^[a-z0-9]{3}[-]?[a-z0-9]{2}$/i

  @@trains = {}

  attr_reader :type, :route, :current_station, :number, :speed, :carriages

  def self.all
    @@trains
  end

  def self.find_by(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    validate!
    @carriages = []
    @speed = INITIAL_SPEED
    @@trains[number] = self
    register_instance
  end

  def each_carriage
    carriages.each.with_index(1) { |carriage, index| yield(carriage, index) }
  end

  def valid?
    validate!
  rescue
    false
  end

  def add_carriage!(carriage)
    raise 'Тип поезда и вагона не соответствуют.' unless type.eql?(carriage.type)

    carriages << carriage if speed.zero?
  end

  def unhook_carriage
    speed.zero? ? unhook_carriage! : (raise 'Прежде чем отцепить вагон остановите поезд.')
  end

  def add_route(route)
    current_station.send_train(self) if current_station
    @route = route

    self.current_station = route.stations.first
  end

  def move(destination)
    raise 'Движение в выбранном направлении невозможно.' unless destination
    increase_speed(5)
    current_station.send_train(self)

    increase_speed(55)
    self.current_station = destination
  end

  def next_station
    position = route.stations.index(current_station)

    current_station == route.stations.last ? (puts 'Конечная') : route.stations[position + 1]
  end

  def prev_station
    position = route.stations.index(current_station)

    current_station == route.stations.first ? (puts 'Конечная') : route.stations[position - 1]
  end

  protected

  def validate!
    raise 'Недопустимый формат номера.' if number !~ NUMBER_FORMAT
    raise "Поезд с номером #{number} уже существует." if @@trains.key?(number)
    true
  end

  def increase_speed(value)
    value.positive? ? @speed = value : (raise 'Некорректное значение для увеличения скорости.')
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
    carriages.count.positive? ? carriages.pop : (raise "Кол-во вагонов: #{carriages.count}")
  end
end

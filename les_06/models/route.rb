class Route
  include IsValid

  @@routes = []

  attr_reader :stations, :start_station, :end_station

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    validate!
    @@routes << self
    @stations = [start_station, end_station]
  end

  def self.all
    @@routes
  end

  def stations_list
    self.stations.each.with_index(1) { |station, index| puts "#{index}. #{station.title}" }
  end

  def add_station!(station)
    self.stations.insert(-2, station)
  end

  def remove_station!(station)
    station.trains.empty? ? self.stations.delete(station) : ( raise 'Нельзя удалить станцию с находящимися на ней поездами. Переместите их.' )
  end

  protected

  def validate!
    raise 'Нельзя добавить несуществующие станции в маршрут.' if !Station.all.include?(start_station && end_station)
    true
  end

end
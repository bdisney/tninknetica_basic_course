class Route
  include Validation

  @@routes = []

  attr_reader :stations, :start_station, :end_station

  validate :start_station, :exists
  validate :end_station,   :exists

  def self.all
    @@routes
  end

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    validate!
    @@routes << self
    @stations = [start_station, end_station]
  end

  def stations_list
    puts "Список станций в маршруте #{title}"
    stations.each.with_index(1) { |station, index| puts "#{index}. #{station.title}" }
  end

  def add_station!(station)
    stations.insert(-2, station)
  end

  def title
    "#{stations.first.title} - #{stations.last.title}"
  end

  def remove_station!(station)
    station.trains.empty? ? stations.delete(station) : (raise 'Перед удалением переместите поезда.')
  end
end

class Route
  include IsValid

  @@routes = []

  attr_reader :stations, :start_station, :end_station

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

  protected

  def validate!
    raise 'Указанные станции не созданы.' unless Station.all.include?(start_station && end_station)
    raise 'Начальная и конечная станции не должны совпадать.' if start_station == end_station
    true
  end
end

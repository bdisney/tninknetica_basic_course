class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def stations_list
    self.stations.each.with_index(1) { |station, index| puts "#{index}. #{station}" }
  end

  def add_station(station)
    self.stations.insert(-2, station)
    puts "Станция «#{station}» добавлена в маршрут #{self}."
  end

  def destroy_station
  end

end
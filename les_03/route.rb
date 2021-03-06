class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def stations_list
    self.stations.each.with_index(1) { |station, index| puts "#{index}. #{station.title}" }
  end

  def add_station(station)
    self.stations.insert(-2, station)
    puts "Станция «#{station.title}» добавлена в маршрут #{self}."
  end

  def remove_station(station)
    if self.stations.include?(station) 
      self.stations.delete(station) 
      puts "Станция #{station} успешно удалена из машртуа #{self.stations.first.title} - #{self.stations.last.title}."
    else
      puts "Станции с названием #{station.title} не содержится в маршруте."
    end
  end
end
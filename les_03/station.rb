class Station

  attr_reader :title, :trains

  def initialize(title)
    @title = title
    @trains = []
  end

  def take_the_train(train)
    self.trains << train
    puts "Поезд следующий по маршруту #{train.route.stations.first} - #{train.route.stations.last} прибыл на станцию #{self.title}"
  end

  def trains_at_the_station
    puts 'Список поездов на станции: '

    self.trains.each.with_index(1) do |train, index|
      puts "\n#{index}. \tПоезд №: #{train.number}"
      puts "\tТип: #{train.type}"
      puts "\tКол-во вагонов: #{train.carriages_qty}"
      puts "\tМаршрут следования: #{train.route.stations.first} - #{train.route.stations.last}"
    end
  end

end
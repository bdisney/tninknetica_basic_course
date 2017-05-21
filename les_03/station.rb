class Station

  attr_reader :title, :trains

  def initialize(title)
    @title = title
    @trains = []
  end

  def take_the_train(train)
    train.stop
    self.trains << train
    puts "Поезд следующий по маршруту #{train.route.stations.first.title} - #{train.route.stations.last.title} прибыл на станцию #{self.title}"
  end

  def send_train(train)
    if self.trains.include?(train) 
      self.trains.delete(train) 

      train.increase_speed(20)
      puts "Поезд отправился со станции #{self.title}"
    else
      puts "Такого поезда на станции #{self.title} нет."
    end
  end

  def trains_at_the_station
    puts 'Список поездов на станции: '

    self.trains.each.with_index(1) do |train, index|
      puts "\n#{index}. \tПоезд №: #{train.number}"
      puts "\tТип: #{train.type}"
      puts "\tКол-во вагонов: #{train.carriages_qty}"
      puts "\tМаршрут следования: #{train.route.stations.first.title} - #{train.route.stations.last.title}"
    end
  end

  def trains_by_type(type)
    self.trains.select.count { |train| train.type if train.type == type}
  end

end
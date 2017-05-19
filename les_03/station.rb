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

  def send_train(train)
    if self.trains.include?(train) 
      self.trains.delete(train) 
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
      puts "\tМаршрут следования: #{train.route.stations.first} - #{train.route.stations.last}"
    end
  end

  def display_trains_by_type
    trains_by_type = Hash.new(0)

    self.trains.each { |train| trains_by_type[train.type] += 1 }
    puts "Поезда на станции #{self.title} по типу: "

    trains_by_type.each { |type, qty| puts "\t#{type}: #{qty} ед." }
    puts "Всего поездов: #{trains_by_type.values.reduce(:+)} ед."
  end
end
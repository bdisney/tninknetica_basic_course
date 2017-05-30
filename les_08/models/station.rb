class Station
  include IsValid

  attr_reader :title, :trains

  @@stations = []

  def initialize(title)
    @title = title
    validate!
    @trains = []
    @@stations << self
  end

  def self.all
    @@stations
  end

  def each_train
    trains.each { |train| yield(train) }
  end

  def trains_at_the_station
    if trains.any?
      each_train do |train|
        puts "\tпоезд №: #{train.number}, тип: #{Train::TYPE[train.type]}"
        train.each_carriage { |carriage, index| puts "\t\t#{index} вагон, доступно: #{carriage.available}" }
        puts "\tмаршрут: #{train.route.title}"
      end
    else
      puts '  ..поездов нет.'
    end
  end

  def trains_by_type(type)
    trains.select { |train| train.type if train.type == type }.count
  end

  def take_the_train(train)
    trains << train
  end

  def send_train(train)
    trains.include?(train) ? trains.delete(train) : (raise 'Такого поезда на станции нет.')
  end

  protected

  def validate!
    raise 'Не короче 3 и больше 15 символов.' unless (3..20).cover?(title.length)
    Station.all.each { |station| raise "Cтанция #{title} существует." if station.title == title }
    true
  end
end

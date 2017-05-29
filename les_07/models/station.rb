class Station
  include IsValid

  attr_reader :title, :trains

  @@stations= []

  def initialize(title)
    @title = title
    validate!
    @trains = []
    @@stations << self
  end

  def self.all
    @@stations
  end

  def each_train(&block)
    self.trains.each  { |train| block.call(train) }
  end

  def trains_at_the_station
    if self.trains.any?
      puts '  ..cписок поездов на станции:'

      self.each_train do |train|
        puts "\tпоезд №: #{train.number}"
        puts "\tтип: #{Train::TYPE[train.type]}"
        puts "\tкол-во вагонов: #{train.carriages.count}"
        train.each_carriage { |carriage,index| puts "\t\t#{index} вагон, доступно: #{carriage.available}" } 
        puts "\tмаршрут следования: #{train.route.stations.first.title} - #{train.route.stations.last.title}"
      end
    else
      puts '  ..поездов нет.'
    end
  end

  def trains_by_type(type)
    self.trains.select { |train| train.type if train.type == type }.count
  end

  def take_the_train(train)
    self.trains << train
  end

  def send_train(train)
    self.trains.include?(train) ? self.trains.delete(train) : ( raise "Такого поезда на станции #{self.title} нет." )
  end

  protected

  def validate!
    raise 'Наименование станции должно быть не короче 3 и больше 15 символов.' if not (3..20).include?(self.title.length) || self.title.nil?
    Station.all.each { |station| raise "Cтанция #{self.title} уже существует." if station.title == self.title }
    true
  end
end
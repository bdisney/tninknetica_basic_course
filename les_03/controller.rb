class Controller

  attr_reader :list_of_stations, :list_of_routes, :list_of_trains

  def initialize
    @list_of_stations = []
    @list_of_routes = {}
    @list_of_trains = {}
  end

  def create_station
    system 'clear'

    print 'Введите название станции: '
    title = gets.strip.downcase.capitalize

    station = Station.new(title)
    add_station_to_list(title)
    puts "Станция #{title} успешно создана."
    gets
  end

  def create_route
    system 'clear'
    puts 'Для создания маршрута выберите начальную и конечную станции.'
    list_of_all_stations

    print 'Выберите начальную станцию, указав порядковый номер: '
    start_station_id = gets.to_i
    @start_station = @list_of_stations[start_station_id - 1]

    print 'Выберите  конечную станцию, указав порядковый номер: '
    end_station_id = gets.to_i
    @end_station = @list_of_stations[end_station_id - 1] 

    if @list_of_stations[end_station_id - 1].nil? || @list_of_stations[start_station_id - 1].nil? 
      puts 'Указан некорректный номер станции. Повторите действие.'
    else
      route = Route.new(@start_station, @end_station)
      
      add_route_to_list(@start_station, @end_station)
      puts list_of_routes
    end
  end 

  def create_train
    system 'clear'
    puts 'Для создания поезда введите его номер, тип и кол-во вагонов: '

    print 'Введите номер: '
    train_number = gets.strip.downcase

    print 'Введите тип. <1> - грузовой, <2> - пассажирский: '
    train_type = gets.to_i

    print 'Введите кол-во вагонов: '
    carriages_qty = gets.to_i

    if train_type != 1 && train_type != 2 
      puts 'Неправильный тип поезда. Попробуйте заново.'
    else
      train = Train.new(train_number, train_type, carriages_qty) 
    end

    add_train_to_list(train_number, train_type, carriages_qty)

    puts 'Маршрут создан'
  end

  def add_station_to_list(title)
   self.list_of_stations << title
  end

  def add_train_to_list(train_number, train_type, carriages_qty)
   self.list_of_trains[train_number] = {train_type: train_type, carriages_qty: carriages_qty}
  end

  def add_route_to_list(start_station, end_station)
    route_title = [start_station, end_station].join('-')
    self.list_of_routes[route_title] = [start_station, end_station]
  end

  def list_of_all_stations
    system 'clear'
    if @list_of_stations.empty?
      puts 'Станций нет.'
    else
      puts "Список станций: "
      @list_of_stations.each.with_index(1) do |title, index|
        puts "#{index}. #{title}"
      end
    end
  end

  def main_actions
    puts 'Выберите действие.'
    puts '1 - Создать станцию' #done
    puts '2 - Создать маршрут' #done
    puts '3 - Создать поезд'
    puts '4 - Список всех станций' #done
    puts '0 - Exit'
  end

  def self.user_choice
    user_choice = gets.to_i
  end

  def execute_action(action)
    case action
    when 1
      create_station
    when 2
      create_route
      gets
    when 3
      create_train
    when 4
      list_of_all_stations
      gets
    when 0
      abort
    else
      puts "Неизвестная команда!"
    end
  end
end
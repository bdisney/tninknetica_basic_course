class Controller
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = {}
  end

  def create_station
    system 'clear'

    print 'Введите название станции: '
    title = gets.strip.downcase.capitalize
    station = Station.new(title)

    add_station_to_list(station)  
    puts "Станция #{station.title} успешно создана."
    puts station #для отладки
    gets
  end

  def create_route
    system 'clear'
    puts 'Для создания маршрута выберите начальную и конечную станции.'
    display_all_stations

    print 'Выберите начальную станцию, указав ее порядковый номер: '
    start_station_id = gets.to_i - 1

    print 'Выберите  конечную станцию, указав ее порядковый номер: '
    end_station_id = gets.to_i - 1

    if self.stations[start_station_id] && self.stations[end_station_id] 
      create_route!(start_station_id, end_station_id)
    else                              
      puts 'Введен несуществующий номер станции'
    end
  end 

  def set_route
    system 'clear'
    train_number = train_selection
    return unless train_number

    puts "\nСписок доступных маршрутов:"
    display_routes

    print 'Выберите маршрут указав его порядковый номер: '
    route_number = gets.to_i - 1

    self.routes[route_number].nil? ? (puts 'Маршрута с таким номером не найдено.') : self.trains[train_number].set_route(routes[route_number])
  end

  def edit_route
    system 'clear'
    display_routes
    print 'Выберите маршрут для редактирования, указав его номер: '
    route_number = gets.to_i - 1 

    route = self.routes[route_number]

    if route.nil? 
      puts 'Маршрута с таким номером не найдено.'
    else
      system "clear"
      puts "Список станций в маршруте #{route.stations.first.title} - #{route.stations.last.title}:"
      route.stations_list

      print '1 - добавить станцию, 2 - удалить станцию: ' 
      choice = gets.to_i

      [1,2].include?(choice) ? choice == 1 ? add_station_to_route(route) : remove_station(route) : (puts 'Некорректное действие')
    end
    gets
  end

  def add_station_to_route(route)
    system 'clear'
    stations_for_adding = @stations - route.stations

    if stations_for_adding.empty?
      puts "Чтобы добавить станцию сначала создайте ее."
    else
      puts 'Можно добавить следующие станции:'
      stations_for_adding.each.with_index(1) {|station, index| puts "#{index}. #{station.title}"} 

      print 'Укажите номер станции, которую хотите добавить: '
      station_number = gets.to_i - 1

      stations_for_adding[station_number] ? route.add_station!(stations_for_adding[station_number]) : (puts 'Некорректный номер станции')
    end
  end

  def remove_station(route)
    stations_for_deleting = route.stations - [route.stations.first] - [route.stations.last]
    puts stations_for_deleting.inspect #для отладки

    if stations_for_deleting.empty?
      puts 'Нельзя удалить начальную и конечную станции маршрута.'
    else
      stations_for_deleting.each.with_index(1) {|station, index| puts "#{index}. #{station.title}"}

      print 'Выберите станцию для удаления: '
      station_number = gets.to_i - 1

      stations_for_deleting[station_number] ? route.remove_station!(stations_for_deleting[station_number]) : (puts 'Некорректный номер станции')
    end
  end

  def create_train
    system 'clear'
    puts 'Для создания поезда введите его номер и тип:'
    print 'Введите номер: '
    number = gets.to_i

    print 'Введите тип. 1 - грузовой, 2 - пассажирский: '
    train_type = gets.to_i

    [1,2].include?(train_type) ? create_train!(number, train_type) : (puts 'Некорректный ввод. Повторите действие.')
  end

  def display_all_trains
    puts self.trains.inspect # для отладки

    puts 'Список всех поездов.'
    self.trains.each.with_index(1) do |(number, train), index|
      puts "\tПоезд № #{number}, тип: #{train.type}, кол-во вагонов: #{train.carriages.count}"
    end
  end

  def add_carriage_to_train
    puts 'Добавление вагона.'
    train_number = train_selection
    return unless train_number

    train = self.trains[train_number]
    create_carriage(train.type) 

    @carriage ? self.trains[train_number].add_carriage(@carriage) : (puts 'Not ok')
    system 'clear'
    puts 'Вагон добавлен'
    gets
  end

  def remove_carriage
    puts 'Отцепить вагон.'
    train_number = train_selection
    return unless train_number

    self.trains[train_number].unhook_carriage
    gets
  end

  def create_carriage(train_type)
    @carriage = CargoCarriage.new if train_type.eql?(:cargo) 
    @carriage = PassengerCarriage.new if train_type.eql?(:passenger)
  end

  def train_selection
    display_all_trains
    print 'Выберите поезд, указав его №: '
    train_number = gets.to_i

    if self.trains.has_key?(train_number)
      return train_number
    else
      puts "Поезда с таким номером не существует."
      gets
      return
    end
  end

  def display_all_stations
    if stations.any? 
      puts 'Список станций:'
      stations.each.with_index(1) do |station, index|
        puts "#{index}. #{station.title}"
        station.trains_at_the_station
      end 
    else
      puts 'Станций нет.'
    end
    gets
  end

  def display_routes
    routes.empty? ? (puts 'Маршрутов нет.') : routes.each.with_index(1) {|route, index| puts "#{index}. #{route.start_station.title} - #{route.end_station.title}"}
  end

  def main_actions
    system 'clear'
    puts 'Выберите действие.'
    puts '1 - Создать станцию' #done
    puts '2 - Создать маршрут' #done
    puts '3 - Редактировать маршрут (добавить/удалить станцию)' #done
    puts '4 - Создать поезд' #done
    puts '5 - Управление движением поезда'
    puts '6 - Добавить вагон' #done
    puts '7 - Отцепить вагон' #done
    puts '8 - Назначить поезду маршрут' #done
    puts '9 - Список всех станций c поездами' #done
    puts '0 - Exit' #done
  end

  def user_choice
    user_choice = gets.to_i
  end

  def execute_action(action)
    case action
    when 1
      create_station
    when 2
      stations.size > 1 ? create_route : (puts 'Для создания маршрута нужно хотя бы 2 станции.')
      gets
    when 3
      routes.empty? ? (puts 'Маршрутов не создано.') : edit_route 
    when 4
      create_train
    when 6
      system 'clear'
      add_carriage_to_train
    when 7
      remove_carriage
    when 8
      set_route
    when 9
      system 'clear'
      display_all_stations
    when 0
      abort
    else
      puts "Неизвестная команда!"
    end
  end

  private

  def create_route!(start_station_id, end_station_id)
    route = Route.new(self.stations[start_station_id], self.stations[end_station_id])
    add_route_to_list(route)
    puts "Маршрут #{route.start_station.title} - #{route.end_station.title} успешно создан."
  end

  def add_route_to_list(route)
    self.routes.push(route)
  end

  def create_train!(number, train_type)
    train_type == 1 ? train = CargoTrain.new(number) : train = PassengerTrain.new(number)
    add_train_to_list(train)
    puts @trains.inspect # для отладки
    puts "#{Train::TYPE[train.type]} поезд № #{train.number} успешно создан."
    gets
  end

  def add_train_to_list(train)
    self.trains[train.number] = train
  end

  def add_station_to_list(station)
    stations.push(station)
  end
end
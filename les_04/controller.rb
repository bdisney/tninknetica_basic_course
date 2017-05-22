class Controller
  attr_reader :list_of_stations, :routes, :trains

  def initialize
    @list_of_stations = []
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

    if self.list_of_stations[start_station_id] && self.list_of_stations[end_station_id] 
      create_route!(start_station_id, end_station_id)
    else                              
      puts 'Введен несуществующий номер станции'
    end
  end 

  def set_route
    train_number = train_selection
    return unless train_number

    puts "\nСписок доступных маршрутов:"
    display_routes

    print 'Выберите маршрут указав его порядковый номер: '
    route_number = gets.to_i - 1

    self.routes[route_number].nil? ? (puts 'Маршрута с таким номером не найдено.') : self.trains[train_number].set_route(routes[route_number])
  end

  # def edit_route
  #   display_list_of_routes
  #   puts 'Выберите маршрут для редактирования.'

  #   print 'Для этого укажите его порядковый номер: '
  #   route_id = gets.to_i - 1

  #   if list_of_routes[route_id]
  #     print "1 - удалить станцию, 2 - добавить"
  #     choice = gets.to_i
  #   else
  #     puts 'Некорректный ввод'
  #     gets
  #   end
  # end

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
    puts 'Список всех поездов.'
    self.trains.each do |(number, train), index|
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
    if list_of_stations.any? 
      puts 'Список станций:'
      list_of_stations.each.with_index(1) {|station, index| puts "#{index}. #{station.title}"} 
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
    #puts '3 - Редактировать маршрут (добавить/удалить станцию)'
    puts '4 - Создать поезд' #done
    #puts '5 - Список поездов'
    puts '6 - Добавить вагон' #done
    puts '7 - Отцепить вагон' #done
    puts '8 - Назначить поезду маршрут' #done
    #puts '8 - Управление движением поезда'
    puts '9 - Список всех станций' 
    puts '0 - Exit' #done
  end

  def 

  def user_choice
    user_choice = gets.to_i
  end

  def execute_action(action)
    case action
    when 1
      create_station
    when 2
      list_of_stations.size > 1 ? create_route : (puts 'Для создания маршрута нужно хотя бы 2 станции.')
      gets
    when 3
      edit_route
    when 4
      create_train
    when 6
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
    route = Route.new(self.list_of_stations[start_station_id], self.list_of_stations[end_station_id])
    add_route_to_list(route)
    puts "Маршрут #{route.start_station.title} - #{route.end_station.title} успешно создан."
  end

  def add_route_to_list(route)
    self.routes.push(route)
  end

  def create_train!(number, train_type)
    train_type == 1 ? train = CargoTrain.new(number) : train = PassengerTrain.new(number)
    add_train_to_list(train)
    puts "#{Train::TYPE[train.type]} поезд № #{train.number} успешно создан."
    gets
  end

  def add_train_to_list(train)
    self.trains[train.number] = train
  end

  def add_station_to_list(station)
    list_of_stations.push(station)
  end
end
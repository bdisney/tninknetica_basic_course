class Controller
  def main_actions
    puts 'Добро пожаловать в он-лайн депо!'
    puts '1 - Создать станцию' 
    puts '2 - Создать маршрут' 
    puts '3 - Редактировать маршрут (добавить/удалить станцию)' 
    puts '4 - Создать поезд' 
    puts '5 - Управление движением поезда' 
    puts '6 - Добавить вагон' 
    puts '7 - Отцепить вагон' 
    puts '8 - Назначить поезду маршрут' 
    puts '9 - Список всех станций c поездами' 
    puts '10 - Купить'
    puts '0 - Exit' 
    print 'Выберите действие: '
  end

  def execute_action(action)
    case action
    when 1
      render(:create_station, true) ; clear_screen
    when 2
      Station.all.size > 1 ? render(:create_route, true) : (puts 'Для создания маршрута нужно хотя бы 2 станции.')
      clear_screen
    when 3
      render(:edit_route) ; clear_screen
    when 4
      render(:create_train, true) ; clear_screen
    when 5
      render(:move_train) ; clear_screen
    when 6
      render(:add_carriage) ; clear_screen
    when 7
      render(:remove_carriage) ; clear_screen
    when 8
      render(:set_route) ; clear_screen
    when 9
      render(:display_all_stations) ; clear_screen
    when 10
      render(:buy) ; clear_screen
    when 0
      abort
    else
      puts 'Некорректный ввод.'
    end
  end

  private

  def render(method, repeat = false)
    self.send(method)
  rescue RuntimeError, TypeError => e
    puts e.message
    retry if repeat
  end

  def create_station
    print 'Введите название станции: '
    title = gets.strip.downcase.capitalize

    station = Station.new(title)
    puts "Станция #{station.title} успешно создана."
  end

  def create_route
    puts "\nДля создания маршрута выберите начальную и конечную станции."
    display_all_stations

    print 'Выберите начальную станцию, указав ее порядковый номер: '
    start_station_id = gets.to_i - 1
    start_station = Station.all[start_station_id] 

    print 'Выберите конечную станцию, указав ее порядковый номер: '
    end_station_id = gets.to_i - 1
    end_station = Station.all[end_station_id]

    start_station && end_station ? create_route!(start_station, end_station) : (raise "\nВведен несуществующий номер станции")
  end 

  def set_route
    if Route.all.any? 
      train = select_train 
      display_routes

      print 'Выберите маршрут указав его порядковый номер: '
      route_number = gets.to_i - 1
      route = Route.all[route_number]

      route.nil? ? (raise "\nМаршрута с таким номером не найдено.") : train.set_route(route)
      puts 'Маршрут назначен.'
    else
      raise "\nПрежде чем назначить маршрут, создайте его."
    end
  end

  def edit_route
    Route.all.any? ? display_routes : ( raise "\nПрежде чем редактировать маршрут, создайте его.")

    print 'Выберите маршрут для редактирования, указав его номер: '
    route_number = gets.to_i - 1 
    route = Route.all[route_number]

    if route.nil? 
      raise "\nМаршрута с таким номером не найдено."
    else
      puts "Список станций в маршруте #{route.stations.first.title} - #{route.stations.last.title}:"
      route.stations_list

      print '1 - добавить станцию, 2 - удалить станцию: ' 
      choice = gets.to_i

      [1,2].include?(choice) ? ( choice == 1 ? add_station_to_route(route) : remove_station(route) ) : (raise 'Некорректное действие')
    end
  end

  def add_station_to_route(route)
    stations_for_adding = Station.all - route.stations

    if stations_for_adding.any?
      puts 'Можно добавить следующие станции:'
      stations_for_adding.each.with_index(1) {|station, index| puts "#{index}. #{station.title}"} 
         
      print 'Укажите номер станции, которую хотите добавить: '
      station_number = gets.to_i - 1

      stations_for_adding[station_number] ? route.add_station!(stations_for_adding[station_number]) : (raise 'Некорректный номер станции')
      puts 'Маршрут обновлен.'
    else
      raise 'Чтобы добавить станцию сначала создайте ее.'
    end
  end

  def remove_station(route)
    stations_for_deleting = route.stations - [route.stations.first] - [route.stations.last]

    if stations_for_deleting.any?
      stations_for_deleting.each.with_index(1) {|station, index| puts "#{index}. #{station.title}"}

      print 'Выберите станцию для удаления: '
      station_number = gets.to_i - 1

      stations_for_deleting[station_number] ? route.remove_station!(stations_for_deleting[station_number]) : (raise 'Некорректный номер станции')
      puts 'Маршрут обновлен.'
    else
      raise 'Нельзя удалить начальную и конечную станции маршрута.'
    end
  end

  def create_train
    puts 'Для создания поезда введите его номер и тип:'
    print 'Введите номер: '
    number = gets.strip

    print 'Введите тип. 1 - грузовой, 2 - пассажирский: '
    train_type = gets.to_i

    [1,2].include?(train_type) ? create_train!(number, train_type) : (raise 'Некорректный ввод. Повторите действие.')
  end

  def move_train
    puts 'Управление движением поезда.'
    train = select_train

    if train && train.route 
      puts "Маршрут #{train.route.stations.first.title} - #{train.route.stations.last.title}"
      puts "Текущая станция: #{train.current_station.title}" 
      puts "Следующая станция: #{train.next_station.title}" if train.next_station
      puts "Предыдущая станция: #{train.prev_station.title}" if train.prev_station
      gets

      print "1 - отправиться на след. станцию. 2 - отправиться на пред. станцию: "
      choice = gets.to_i

      [1,2].include?(choice) ? ( choice == 1 ? train.move(train.next_station) : train.move(train.prev_station) ) : ( raise "Некорректная команда." )
      puts "Поезд прибыл на станцию #{train.current_station.title}"
    else
      raise 'Прежде чем начать движение назначьте поезду маршрут.'
    end
  end

  def display_all_trains
    Train.all.each.with_index(1) { |(number, train), index| puts "\tПоезд № #{number}, тип: #{train.type}, кол-во вагонов: #{train.carriages.count}" }
  end

  def add_carriage
    train = select_train
    create_carriage(train.type)

    train.add_carriage!(@carriage) if @carriage 
    puts 'Вагон добавлен'
  end

  def remove_carriage
    train = select_train
    train.unhook_carriage
    puts 'Вагон отцеплен.'
  end

  def create_carriage(type)
    type.eql?(:cargo) ? ( print 'Объем грузового вагона, в тоннах: ' ) : ( print 'Количество мест: ' )
    capacity = gets.to_i

    if capacity.positive? 
      @carriage = CargoCarriage.new(capacity) if type.eql?(:cargo)
      @carriage = PassengerCarriage.new(capacity) if type.eql?(:passenger)
    else
      raise 'Недопустимое значение.'
    end
  end

  def select_train
    Train.all.any? ? display_all_trains : ( raise 'Поездов нет' )
    
    print 'Выберите поезд, указав его №: '
    train_number = gets.strip

    train = Train.find_by(train_number) 
    train ? train : ( raise 'Нет поезда с таким номером' )
  end

  def buy
    train = select_train
    
    if train.carriages.any? 
      puts 'Список вагонов:'
      train.each_carriage {|carriage, index| puts "\t#{index} вагон, доступно - #{carriage.available}"}
    else
      raise 'У поезда нет вагонов.'
    end

    print "Выберите вагон, указав его номер: "
    carriage_number = gets.to_i - 1

    if carriage_number.negative? 
      raise 'Некорректный ввод'
    elsif train.type.eql?(:passenger)
      train.carriages[carriage_number].take_the_seat 
      puts "Место приобретено. Доступных мест: #{train.carriages[carriage_number].available}"
    else
      print "Какой объем вам нужен?: "
      volume = gets.to_f

      train.carriages[carriage_number].fill_in(volume)
      puts "Загружено #{volume} т. Доступно для загрузки: #{train.carriages[carriage_number].available} т."
    end
  end

  def display_all_stations
    if Station.all.any? 
      puts 'Список станций:'

      Station.all.each.with_index(1) do |station, index|
        puts "#{index}. #{station.title}"
        station.trains_at_the_station
      end 
    else
      puts 'Станций нет.'
    end
  end

  def display_routes
    Route.all.each.with_index(1) {|route, index| puts "#{index}. #{route.start_station.title} - #{route.end_station.title}"}
  end

  def create_route!(start_station, end_station)
    route = Route.new(start_station, end_station)
    puts "Маршрут #{route.start_station.title} - #{route.end_station.title} успешно создан."
  end

  def create_train!(number, train_type)
    train_type == 1 ? train = CargoTrain.new(number) : train = PassengerTrain.new(number)
    puts "#{Train::TYPE[train.type]} поезд № #{train.number} успешно создан."
  end

  def clear_screen
    gets
    system 'clear'
  end
end
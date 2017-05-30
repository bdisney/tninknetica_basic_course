class Controller
  MAIN_ACTIONS = {
    '1'  => { method: :create_station, repeat: true },
    '2'  => { method: :create_route },
    '3'  => { method: :edit_route },
    '4'  => { method: :create_train, repeat: true },
    '5'  => { method: :move_train },
    '6'  => { method: :add_carriage },
    '7'  => { method: :remove_carriage },
    '8'  => { method: :set_route },
    '9'  => { method: :display_all_stations },
    '10' => { method: :buy }
  }.freeze

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

  def render_action(user_choice)
    action = MAIN_ACTIONS.fetch(user_choice)
    render(action[:method], action[:repeat])
    clear_screen
  rescue KeyError
    puts 'Некорректный ввод'
  end

  private

  def render(method, repeat = false)
    send(method)
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
    raise 'Для создания маршрута нужно хотя бы 2 станции' unless Station.all.size > 1
    puts "\nДля создания маршрута выберите начальную и конечную станции."
    display_all_stations

    print 'Выберите начальную станцию, указав номер: '
    start_station = select_station

    print 'Выберите конечную станцию, указав номер: '
    end_station = select_station

    create_route!(start_station, end_station)
  end

  def set_route
    raise "\nПрежде чем назначить маршрут, создайте его." unless Route.all.any?
    train = select_train
    display_routes
    route = select_route

    route.nil? ? (raise "\nМаршрута с таким номером не найдено.") : train.add_route(route)
    puts 'Маршрут назначен.'
  end

  def edit_route
    raise 'Прежде чем редактировать маршрут, создайте его.' unless Route.all.any?
    display_routes
    route = select_route

    puts "Список станций в маршруте #{route.title}:"
    route.stations_list

    print '1 - добавить станцию, 2 - удалить станцию: '
    choice = gets.to_i
    raise 'Некорректное действие' unless [1, 2].include?(choice)

    choice == 1 ? add_station_to_route(route) : remove_station(route)
  end

  def add_station_to_route(route)
    fit_stations = Station.all - route.stations
    raise 'Чтобы добавить станцию сначала создайте ее.' unless fit_stations.any?

    puts 'Можно добавить следующие станции:'
    fit_stations.each.with_index(1) { |station, index| puts "#{index}. #{station.title}" }

    print 'Укажите номер станции, которую хотите добавить: '
    id = gets.to_i - 1

    fit_stations[id] ? route.add_station!(fit_stations[id]) : (raise 'Некорректный ввод')
    puts 'Маршрут обновлен.'
  end

  def remove_station(route)
    fit_stations = route.stations - [route.stations.first] - [route.stations.last]
    raise 'Нельзя удалить начальную и конечную станции маршрута.' unless fit_stations.any?

    fit_stations.each.with_index(1) { |station, index| puts "#{index}. #{station.title}" }
    print 'Выберите станцию для удаления: '
    id = gets.to_i - 1

    fit_stations[id] ? route.remove_station!(fit_stations[id]) : (raise 'Некорректный ввод')
    puts 'Маршрут обновлен.'
  end

  def create_train
    puts 'Для создания поезда введите его номер и тип:'
    print 'Введите номер: '
    number = gets.strip

    print 'Введите тип. 1 - грузовой, 2 - пассажирский: '
    train_type = gets.to_i

    [1, 2].include?(train_type) ? create_train!(number, train_type) : (raise 'Некорректный ввод.')
  end

  def move_train
    puts 'Управление движением поезда.'
    train = select_train
    raise 'Прежде чем начать движение назначьте поезду маршрут.' unless train && train.route

    puts "Маршрут #{train.route.title}"
    puts "Текущая станция: #{train.current_station.title}"
    puts "Следующая станция: #{train.next_station.title}" if train.next_station
    puts "Предыдущая станция: #{train.prev_station.title}" if train.prev_station
    gets

    print '1 - отправиться на след. станцию. 2 - отправиться на пред. станцию: '
    raise 'Некорректная команда.' unless [1, 2].include?(choice = gets.to_i)

    choice == 1 ? train.move(train.next_station) : train.move(train.prev_station)
    puts "Поезд прибыл на станцию #{train.current_station.title}"
  end

  def display_all_trains
    Train.all.each { |number, train| puts "\tПоезд № #{number}, тип: #{train.type}, кол-во вагонов: #{train.carriages.count}" }
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
    type.eql?(:cargo) ? (print 'Объем грузового вагона, в тоннах: ') : (print 'Количество мест: ')
    raise 'Недопустимое значение.' unless (capacity = gets.to_i).positive?

    @carriage = CargoCarriage.new(capacity) if type.eql?(:cargo)
    @carriage = PassengerCarriage.new(capacity) if type.eql?(:passenger)
  end

  def select_train
    Train.all.any? ? display_all_trains : (raise 'Поездов нет')
    print 'Выберите поезд, указав его №: '
    number = gets.strip

    train = Train.find_by(number)
    train ? train : (raise 'Нет поезда с таким номером')
  end

  def select_route
    print 'Выберите маршрут указав его порядковый номер: '
    route_number = gets.to_i - 1

    route = Route.all[route_number]
    route ? route : (raise 'Маршрут не найден.')
  end

  def select_station
    id = gets.to_i - 1
    station = Station.all[id]
    station ? station : (raise 'Некорректный ввод')
  end

  def buy
    train = select_train
    raise 'У поезда нет вагонов.' unless train.carriages.any?
    puts 'Список вагонов:'
    train.each_carriage { |carriage, index| puts "\t#{index} вагон, доступно - #{carriage.available}" }

    print 'Выберите вагон, указав его номер: '
    raise 'Некорректный ввод' if (carriage_number = gets.to_i - 1).negative?

    if train.type.eql?(:passenger)
      train.carriages[carriage_number].take_the_seat
      puts "Место приобретено. Доступных мест: #{train.carriages[carriage_number].available}"
    else
      print 'Какой объем вам нужен?: '
      train.carriages[carriage_number].fill_in(volume = gets.to_f)
      puts "Загружено #{volume} т. Доступно: #{train.carriages[carriage_number].available} т."
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
    Route.all.each.with_index(1) { |route, index| puts "#{index}. #{route.title}" }
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

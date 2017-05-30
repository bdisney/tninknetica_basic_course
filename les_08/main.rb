require_relative 'controllers/controller.rb'

require_relative 'modules/vendor.rb'
require_relative 'modules/instance_counter.rb'
require_relative 'modules/is_valid.rb'

require_relative 'models/route.rb'
require_relative 'models/station.rb'

require_relative 'models/cargo_train.rb'
require_relative 'models/passenger_train.rb'

require_relative 'models/cargo_carriage.rb'
require_relative 'models/passenger_carriage.rb'

system 'clear'

controller = Controller.new

loop do
  controller.main_actions
  user_choice = gets.strip
  break if user_choice == '0'
  controller.render_action(user_choice)
end

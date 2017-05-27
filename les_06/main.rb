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

def self.user_choice
  user_choice = gets.to_i
end

controller = Controller.new

loop do
  controller.main_actions
  controller.execute_action(user_choice)
end
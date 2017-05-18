require_relative 'train.rb'
require_relative 'route.rb'
require_relative 'station.rb'
require_relative 'controller.rb'

def self.user_choice
  user_choice = gets.to_i
end

controller = Controller.new

puts 'Добро пожаловать в он-лайн депо'

loop do
  controller.main_actions
  controller.execute_action(user_choice)
end
require_relative 'train.rb'

class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :uniqueness

  def initialize(number)
    super
    @type = :passenger
  end
end

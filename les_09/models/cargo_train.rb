require_relative 'train.rb'

class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :uniqueness

  def initialize(number)
    super
    @type = :cargo
  end
end

require_relative 'company_name'
require_relative 'instance_counter'
require_relative 'validate'

class Wagon
  WAGON_NUMBER_FORMAT = /^\d{1,}$/

  @wagons = {}

  include CompanyName
  include InstanceCounter
  include Validate

  attr_reader :name, :number, :type

  class << self
    def all
      @wagons
    end

    def add_wagon(wagon)
      @wagons[wagon.name] = wagon
    end
  end

  def initialize(name, number, _volume)
    @name = name
    @number = number.to_s
    self.class.register_instance
    validate!
  end

  private

  def validate!
    raise "Name can't be nil!" if name.nil?
    raise "Number can't be nil!" if number.nil?
    raise 'Wrong number format!' if WAGON_NUMBER_FORMAT !~ number
  end
end

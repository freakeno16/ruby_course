require_relative 'company_name.rb'
require_relative 'validate.rb'
require_relative 'instance_counter.rb'

class Wagon
  @wagons = {}

  include CompanyName
  include Validate
  include InstanceCounter

  attr_reader :name, :volume, :occupated_volume, :type

  class << self 
    def all
      @wagons
    end
  
    def add_wagon(wagon)
      @wagons[wagon.name] = wagon
    end
  end
  
  def initialize(name, volume)
    @name = name
    @volume = volume
    @occupated_volume = 0
    self.class.register_instance
    validate!
  end

  protected

  def validate!
    raise "Name can't be nil!" if name.nil?
    # raise "Wrong wagon type!" if type != "passenger" && type != "freight"
  end
end
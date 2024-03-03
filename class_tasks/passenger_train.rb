class PassengerTrain < Train
  attr_reader :type

  def initialize(name, number)
    super
    @type = 'passenger'
    validate!
  end

  private 

  def validate!
    super
    # raise "Wrong train type" if type != 'passenger'
  end
end

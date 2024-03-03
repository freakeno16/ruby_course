class FreightTrain < Train
  attr_reader :type

  def initialize(name, number)
    super
    @type = 'freight'
    validate!
  end

  private

  def validate!
    super
    # raise "Wrong train type" if type != 'freight'
  end
end
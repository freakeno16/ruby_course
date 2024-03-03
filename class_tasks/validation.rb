module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validations
      @validations
    end

    def validate(name, type, arg=nil)
      
      @validations ||= [] 
      case type
      when :presence
      
        # validations << "p send(instance_eval(\":#{name}\"))"
        validations << "lambda {raise \"Value can't be empty string or nil!\" if ['', nil].include?(send(instance_eval(\":#{name}\")))}"

      # when :format
      #   validations << "raise 'Value must be match the regexp!' if #{instance_eval("@#{name}")} !~ #{arg}"
      # when :type
      #   validations << "raise 'Value must be match the class!' unless #{instance_eval("@#{name}")}.is_a?(#{arg})"
      end

      instance_variable_set("@validations", (instance_variable_get("@validations") || []) + validations)
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |v|
        foo = eval(v)
        p foo.call
      end
    end
  end
end

class Foo
  attr_reader :a

  include Validation
  
  validate :a, :presence

  def initialize(a)
    @a = a
    validate!
  end
end

f = Foo.new 123

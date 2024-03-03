module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |arg|
        var_name = "@#{arg}".to_sym

        define_method(arg) { instance_variable_get(var_name) }

        define_method("#{arg}=") do |value|
          old = instance_variable_get(var_name)
          if instance_variable_get("@#{arg}_old")
            instance_variable_set("@#{arg}_old", instance_variable_get("@#{arg}_old") << old)
            instance_variable_set(var_name, value)
          else
            instance_variable_set(var_name, value)
            instance_variable_set("@#{arg}_old", [old])
          end
        end
        define_method("#{arg}_history") { instance_variable_get("@#{arg}_old") || [] }
      end
    end

    def strong_attr_accessor(attr_name, attr_class)
      var_name = "@#{attr_name}".to_sym

      define_method(attr_name) { instance_variable_get(var_name) }
      define_method("#{attr_name}=") do |value|
        raise "Wrong attr_class, must be #{attr_class}, retry please" unless value.is_a? attr_class

        instance_variable_set(var_name, value)
      end
    end
  end
end

class Foo 
  include Accessors
  attr_accessor_with_history :a, :b

  def initialize(a)
    @a = a 
  end
end
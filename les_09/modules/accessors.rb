module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |arg|
        var_name = "@#{arg}".to_sym

        define_method(arg) { instance_variable_get(var_name) }

        define_method("#{arg}=".to_sym) do |value|
          instance_variable_set(var_name, value)

          @var_history ||= {}
          @var_history[var_name] ||= []
          @var_history[var_name] << value
        end

        define_method("#{arg}_history") { @var_history[var_name] }
      end
    end
  end
end

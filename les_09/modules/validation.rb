module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :rules

    def validate(name, validate_method, *options)
      @rules ||= []
      @rules << { validate_method: validate_method, name: name, options: options }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue
      false
    end

    protected

    def validate!
      self.class.rules.each do |rule|
        value = instance_variable_get("@#{rule[:name]}")
        with_arg = rule # unnecessary string, just for better understanding
        send rule[:validate_method], with_arg[:name], value, with_arg[:options].first
      end
      true
    end

    def presence(name, value, *_option)
      raise "#{self.class} #{name.capitalize} не может быть пустым." if value.to_s.empty?
    end

    def length_in_range(name, value, range)
      raise 'Не короче 3 и больше 15 символов.' unless range.cover?(value.length)
    end

    def format(name, value, regexp)
      raise "Недопустимый формат для #{name}." if value !~ regexp
    end

    def type(name, value, klass)
      raise "Тип объекта не соответствует заданному классу." unless is_a?(klass)
    end

    def uniqueness(name, value, *_option)
      if is_a?(Station)
        self.class.all.each { |object| raise "Станция #{value} уже есть." if object.send(name) == value && object != self }
      elsif is_a?(Train)
        raise "Поезд № #{value} уже есть." if self.class.all[value] && self.class.all[value] != self
      end
    end

    def exists(name, value, *_option)
      raise "Станция не существует" unless Station.all.include?(value)
    end
  end
end

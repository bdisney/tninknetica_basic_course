module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instance_qty
      @instances
    end

    private
    
    def count_instances(instance) 
      @instances ||= 0
      @instances += instance
    end
  end

  module InstanceMethods
    private

    def register_instance
      instance = 1
      self.class.send(:count_instances, instance)
    end
  end
end
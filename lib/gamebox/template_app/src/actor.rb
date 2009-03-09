require 'inflector'
# Actor represent a game object.
# Actors can have behaviors added and removed from them.
class Actor
  attr_accessor :behaviors

  def initialize
    @behaviors = {}
    # add our classes behaviors
    class_behaviors = self.class.behaviors.dup
    for behavior in class_behaviors
      is behavior
    end
  end

  def is?(behavior_sym)
    @behaviors[behavior_sym]
  end

  def is(behavior_sym)
    begin
      require behavior_sym.to_s;
    rescue LoadError
      # maybe its included somewhere else
    end
    klass = Object.const_get Inflector.camelize(behavior_sym)
    @behaviors[behavior_sym] = klass.new self
  end

  def is_no_longer(behavior_sym)
    @behaviors.delete behavior_sym
  end

  def update_behaviors(time)
    for behavior in @behaviors.values
      behavior.update time
    end
  end

  # to be defined in child class
  def update(time)
  end

  # to be defined in child class
  def draw(target)
  end

  # Get a metaclass for this class
  def self.metaclass; class << self; self; end; end

  # magic
  metaclass.instance_eval do
    define_method( :behaviors ) do
      @behaviors ||= []
    end
    define_method( :has_behaviors ) do |*args|
      @behaviors ||= []
      for a in args
        @behaviors << a
      end
      p @behaviors
      @behaviors
    end
  end
end

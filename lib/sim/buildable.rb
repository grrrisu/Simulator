require 'yaml'

module Sim

  # usage:
  #
  # class Animal
  #   default_attr :max, 8
  # end
  #
  # class Wolf
  #   default_attr :size, 7
  # end
  #
  # config = Wolf.load_config('wolf.yml')  # hunger: 6
  # wolf = Wolf.build(config, :min => 3)
  #
  # values are set in the following priority:
  #
  # wolf.min     # => 3  from options
  # wolf.hunger  # => 6  from yaml config
  # wolf.size    # => 7  from default class
  # wolf.max     # => 8  from default superclass
  #
  # WereWolf = Class.new(Wolf)
  # WereWolf.set_defaults size: 10, strenght: 20
  # werewolf = WereWolf.build
  # werewolf.size     # => 10
  # werewolf.strength # => 20
  module Buildable

    def self.load_config file_name
      YAML.load(File.open(file_name)).deep_symbolize_keys
    end

    def Buildable.included other
      class << other
        include ClassMethods
      end
      other.send(:include, InstanceMethods)
    end

    module ClassMethods

      def load_config file_name
        Buildable.load_config file_name
      end

      def default_attr name, value = nil
        attr_accessor name.to_sym
        @defaults ||= {}
        @defaults[name.to_sym] = value
      end

      def set_defaults values = {}
        @defaults ||= {}
        values.keys.each {|a| attr_accessor a.to_sym }
        @defaults.merge!(values)
      end

      def defaults
        default_attributes = @defaults || {}
        if superclass.respond_to? :defaults
          default_attributes = superclass.defaults.merge(default_attributes)
        end
        default_attributes
      end

      def build config = {}, options = {}
        attributes = defaults.merge(config).merge(options.symbolize_keys)
        buildable = new *initialize_parameters(attributes)
        attributes.each do |key, value|
          if buildable.respond_to?("#{key}=".to_sym)
            buildable.send("#{key}=", convert_build_value(value))
          end
        end
        buildable.build(config)
        buildable
      end

      def initialize_parameters attributes
        parameter_names = instance_method(:initialize).parameters.map {|p| p[1]}
        parameter_names.map do |name|
          attributes[name]
        end.compact
      end

      def convert_build_value value
        case value.class.name
          when 'Range'
            # sets a random integer within the specified range
            value.first + rand(value.last - value.first)
          else
            value
        end
      end

    end

    module InstanceMethods

      # post initialize process
      def build config
        # implement in subclass
      end

    end

  end

end

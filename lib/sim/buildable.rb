require 'yaml'

module Sim

  # usage:
  #
  # config = Wolf.load_config('wolf.yml')
  # wolf = Wolf.build(config, :min => 3)
  #
  # values are set in the following priority:
  #
  # wolf.min == 3 # options
  # wolf.hunger == 6 # yaml config
  # wolf.size == 7 # default class
  # wolf.max == 8 # default superclass
  module Buildable

    def Buildable.included other
      class << other
        include ClassMethods
      end
    end

    module ClassMethods

      def default_attr name, value = nil
        attr_accessor name.to_sym
        @defaults ||= {}
        @defaults[name.to_s] = value
      end

      def defaults
        default_attributes = @defaults || {}
        if superclass.respond_to? :defaults
          default_attributes = superclass.defaults.merge(default_attributes)
        end
        default_attributes
      end

      def build config, options = {}
        # convert sym keys to string keys
        options = options.inject({}) do |memo, item|
          memo[item[0].to_s] = item[1]
          memo
        end
        attributes = defaults.merge(config).merge(options)
        buildable = new
        attributes.each do |key, value|
          buildable.send("#{key}=", convert_build_value(value))
        end
        buildable
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

      def load_config file_name
        YAML.load(File.open(file_name))
      end

    end

  end

end
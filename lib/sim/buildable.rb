module Sim

  module Buildable

    def Buildable.included other
      other.instance_eval {include InstanceMethods}
      class << other
        include ClassMethods
      end
    end

    module ClassMethods

      def build_option_key
        @build_option_key || name
      end

      # @param attributes [Hash]
      def default attributes
        @default = attributes
      end

      def default_get
        default_attributes = @default || {}
        if superclass.respond_to? :default_get
          default_attributes = superclass.default_get.merge(default_attributes)
        end
        default_attributes
      end

      def build options = {}
        if buildable = build_for(build_option_key, options)
          buildable.after_build
        end
        buildable
      end

      def build_for key, options = {}
        begin
          options = Level.current.build_options.fetch(key).merge options
        rescue NameError
          nil # NameError raised if Level.current is not set
        rescue IndexError
          nil
        ensure
          options = default_get.merge options
        end
        buildable = new
        buildable.initialize_attributes options
        buildable
      end

      def build_options *attributes
        build_options_for build_option_key, *attributes
      end

      def build_options_for key, *attributes
        begin
          options = Level.current.build_options.fetch key
          options = default_get.merge options
        rescue NameError
          # NameError raised if Level.current is not set
          options = default_get
        rescue IndexError
          options = default_get
        end
        unless attributes.empty?
          values = attributes.collect {|a| options[a] }
          values.length == 1 ? values[0] : values
        else
          options
        end
      end

    end

    module InstanceMethods

      def initialize_attributes attributes = {}
        attributes.each do |variable, value|
          if value.instance_of? Range then value = range_to_i(value) end
          send "#{variable}=", value
        end
      end

      def initialize_attributes_with_defaults attributes = {}
        initialize_attributes self.class.default_get.merge(attributes)
      end

      # sets a random integer within the specified range
      def range_to_i range
        range.first + rand(range.last - range.first)
      end

      def after_build
      end

      def delete
        after_delete if before_delete
      end

      def before_delete
        true
      end

      def after_delete
      end

    end

  end

end

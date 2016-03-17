module Sim
  module Queue
    module Event
      class SimEvent < Base

        attr_reader :object

        def initialize object
          @object = object or raise ArgumentError, "sim object must be set"
          @done = false
        end

        def to_s
          "<#{self.class} object=#{object.class} x: #{object.field.x} y: #{object.field.y}>"
        end

        def notify area
          if area
            #event_broadcaster.async.notify(area)
          end
        end

        def fire
          changed_area = object.update_simulation
          notify(changed_area)
        end

      end

    end
  end
end

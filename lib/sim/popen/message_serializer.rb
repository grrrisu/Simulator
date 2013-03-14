require 'json'

module Sim
  module Popen

    module MessageSerializer

      def MessageSerializer.included other
        other.class_eval do
          attr_accessor :input, :output
        end
      end

      def send_data object
        data = JSON.dump(object)
        @output.write [data.respond_to?(:bytesize) ? data.bytesize : data.size, data].pack('Na*')
        @output.flush
      end

      def receive_data
        size_data = @input.read(4)
        if size_data
          size = size_data.unpack('N').first
          data = @input.read(size)
          JSON.load(data)
        else
          raise EOFError
        end
      end

    end

  end
end

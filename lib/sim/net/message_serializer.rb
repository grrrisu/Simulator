require 'json'

module Sim
  module Net

    module MessageSerializer

      def MessageSerializer.included other
        other.class_eval do
          attr_accessor :input, :output
        end
      end

      def send_data object
        data = JSON.dump(object)
        data = data.force_encoding('UTF-8')
        @output.write [data.respond_to?(:bytesize) ? data.bytesize : data.size, data].pack('Na*')
        @output.flush
      end

      def receive_data
        size_data = @input.read(4)
        if size_data
          size = size_data.unpack('N').first
          data = @input.read(size)
          JSON.parse(data, symbolize_names: true)
        else
          raise EOFError, "received size data #{size_data.inspect}"
        end
      end

    end

  end
end

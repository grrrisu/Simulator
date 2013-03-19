require 'json'

module Sim
  class Matrix
    include Enumerable

    extend Forwardable
    def_delegators :@matrix, :to_s, :to_json, :flatten, :inspect

    def initialize columns, rows = nil, default = nil
      rows = columns unless rows
      @matrix = Array.new(rows) { Array.new(columns){ default } }
    end

    # size of matrix [x,y]
    def size
      [width, height]
    end

    def width
      @matrix.first.size
    end

    def height
      @matrix.size
    end

    def fields
      @matrix
    end

    def each_field
      @matrix.each do |row|
        row.each {|field| yield field}
      end
    end

    alias each each_field

    def each_field_with_index
      @matrix.each_with_index do |row, y|
        row.each_with_index {|field, x| yield field, x, y}
      end
    end

    def set_each_field
      @matrix.each_with_index do |row, y|
        row.each_with_index {|field, x| self[x,y] = yield}
      end
    end

    def set_each_field_with_index
      @matrix.each_with_index do |row, y|
        row.each_with_index {|field, x| self[x, y] = yield x, y}
      end
    end

    def slice x, y, width, height = nil
      height = width unless height
      height.times do |j|
        width.times do |i|
          yield self[x + i, y + j]
        end
      end
    end

    def slice_with_index x, y, width, height = nil
      height = width unless height
      height.times do |j|
        width.times do |i|
          yield self[x + i, y + j], x + i, y + j
        end
      end
    end

    def set_slice x, y, width, height = nil
      height = width unless height
      height.times do |j|
        width.times do |i|
          set_field(x + i, y + j, yield)
        end
      end
    end

    def set_slice_with_index x, y, width, height = nil
      height = width unless height
      height.times do |j|
        width.times do |i|
          set_field(x + i, y + j, yield(x + i, y + j))
        end
      end
    end

    def get_field x, y
      @matrix.fetch(y).fetch(x)
    end
    # matrix[1,0] #=> value
    alias [] get_field

    def set_field x, y, value
      @matrix[y][x] = value
    end
    # matrix[1,0] = value
    alias []= set_field

    def field_as_string x, y, property
      self[x,y].try(:[],property).to_s
    end

  end
end

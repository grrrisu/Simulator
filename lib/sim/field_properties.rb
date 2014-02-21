require 'hashie'

module Sim

  class FieldProperties < Hashie::Mash
    #include Hashie::Extensions::MethodAccess

    # def []= name, value
    #   name = name.to_sym
    #   super
    #   unless respond_to? "has_#{name}?".to_sym
    #     self.class.class_eval do
    #       define_method name.to_sym do
    #         self[name]
    #       end
    #       define_method "has_no_#{name}?".to_sym do
    #         self[name.to_sym].nil?
    #       end
    #       define_method "has_#{name}?".to_sym do
    #         not self[name.to_sym].nil?
    #       end
    #     end
    #   end
    # end

    # def set properties_and_values
    #   merge!(properties_and_values)
    # end

  end

end

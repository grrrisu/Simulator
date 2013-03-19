module Sim

  class FieldProperties < Hash

    def []= name, value
      name = name.to_sym
      super
      unless respond_to? "has_#{name}?".to_sym
        self.class.class_eval do
          define_method name.to_sym do
            self[name]
          end
          define_method "has_no_#{name}?".to_sym do
            self[name.to_sym].nil?
          end
          define_method "has_#{name}?".to_sym do
            not self[name.to_sym].nil?
          end
        end
      end
    end

  end

end

require 'active_record'

# Autoserialize
module AutoSerialize #:nodoc:
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def autoserialize(attribute, format=:json, db_column=nil, default_value={})
      format = validate_serialization_format!(format)
      db_column ||= :"#{attribute}_#{format}"
      class_name = self.name

      options_str = ''
      if default_value.respond_to?('with_indifferent_access')
        options_str += '.with_indifferent_access'
      end
      default_value = default_value.inspect

      define_methods_str = <<END_DEFINE_METHODS_STRING
        def save_#{attribute}
          self.#{db_column} = #{class_name}.to_#{format}(@#{attribute}) if @#{attribute}
        end
        before_validation :save_#{attribute}

        def #{attribute}
          return @#{attribute} if @#{attribute}
          @#{attribute} = ( self.#{db_column} ? #{class_name}.from_#{format}(self.#{db_column}) || #{default_value} : #{default_value} )#{options_str}
        end

        def #{attribute}=(attr)
          self.#{db_column} = #{class_name}.to_#{format}(attr)
        end

        def #{db_column}=(attr_#{format})
          self[:#{db_column}] = attr_#{format}
          @#{attribute} = nil # Clear the cached #{attribute}
        end
END_DEFINE_METHODS_STRING
      self.send(:class_eval, define_methods_str)
    end

    def to_json(object)
      object.to_json
    end
    def from_json(object_str)
      return nil if object_str == "null"
      ActiveSupport::JSON.decode(object_str)
    end

    protected
    VALID_FORMATS = [:json]
    def validate_serialization_format!(format)
      format = format.to_sym
      if !VALID_FORMATS.include?(format)
        raise "Unhandled serialization format #{format.inspect}"
      end
      format
    end
  end
end

ActiveRecord::Base.send(:include, AutoSerialize)

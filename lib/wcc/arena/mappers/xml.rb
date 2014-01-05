module WCC::Arena::Mappers

  module XML

    attr_reader :document

    def initialize(document)
      @document = document
    end

    def [](attribute)
      if config = self.class.attributes[attribute]
        path = document.xpath(config[:xpath])
        path.text if path.size > 0
      else
        raise KeyError, "Attribute #{attribute} is not defined"
      end
    end

    module ClassMethods

      def attribute(name, options)
        options.fetch(:xpath) {
          raise ArgumentError, ":xpath is a required argument to the `attribute' method"
        }
        attributes[name] = options.freeze
        define_method(name) { self[name] }
      end

      def attributes
        @attributes ||= {}
      end

      def inherited(subclass)
        subclass.instance_variable_set(:@attributes, attributes.dup)
      end

    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end

  end

end

module WCC::Arena::Mappers

  module XML

    attr_reader :document

    def initialize(document)
      @document = document
    end

    def [](attribute)
      if config = self.class.attributes[attribute]
        node = document.xpath(config[:xpath])
        node.text if node.size > 0
      else
        raise KeyError, "Attribute #{attribute} is not defined"
      end
    end

    def attributes
      self.class.attributes.each_with_object({}) do |(name, options), hash|
        hash[name] = self[name]
      end
    end

    def inspect
      "<#{self.class.name}" \
      "#{attributes.collect { |(name, value)| [name, value.inspect].join("=") }.join(" ")}>"
    end

    def load_association(name)
      if config = self.class.associations[name]
        document.xpath(config[:xpath]).collect do |node|
          config[:klass].new(node)
        end
      end
    end
    private :load_association

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

      def associations
        @associations ||= {}
      end

      def has_many(name, options)
        options.fetch(:xpath) {
          raise ArgumentError, ":xpath is a required argument to the `has_many' method"
        }
        options.fetch(:klass) {
          raise ArgumentError, ":klass is a required argument to the `has_many' method"
        }
        associations[name] = options.freeze
        define_method(name) do
          @association_cache ||= {}
          @association_cache[name] ||= load_association(name)
        end
      end

      def inherited(subclass)
        super
        subclass.instance_variable_set(:@attributes, attributes.dup)
        subclass.instance_variable_set(:@associations, associations.dup)
      end

    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end

  end

end

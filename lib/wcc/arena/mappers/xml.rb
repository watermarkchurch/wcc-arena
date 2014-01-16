require 'date'
require 'time'

module WCC::Arena::Mappers

  module XML

    attr_reader :document

    def initialize(document)
      @document = document
    end

    def [](attribute)
      if self.class.attributes[attribute]
        load_attribute(attribute)
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
      "<#{self.class.name} " \
      "#{attributes.collect { |(name, value)| [name, value.inspect].join("=") }.join(" ")}>"
    end

    def load_association(name)
      if config = self.class.associations[name]
        list = document.xpath(config[:xpath]).collect do |node|
          config[:klass].new(node)
        end
        case config[:type]
        when :many
          list
        when :one
          list.first
        end
      end
    end
    private :load_association

    def load_attribute(attribute)
      config = self.class.attributes[attribute]
      node = document.xpath(config[:xpath])
      cast_attribute(node.text, config[:type])
    end

    def cast_attribute(text, type)
      return nil if text.empty?

      case type
      when :integer
        Integer(text)
      when :date
        Date.strptime(text.split("T").first, "%Y-%m-%d")
      when :time
        Time.parse(text)
      when :boolean
        text.downcase == "true"
      else
        text
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

      def associations
        @associations ||= {}
      end

      def has_one(name, options)
        add_association(name, options.merge(type: :one)) do
          @association_cache ||= {}
          @association_cache[name] ||= load_association(name)
        end
      end

      def has_many(name, options)
        add_association(name, options.merge(type: :many)) do
          @association_cache ||= {}
          @association_cache[name] ||= load_association(name)
        end
      end

      def add_association(name, options, &block)
        options.fetch(:xpath) {
          raise ArgumentError, ":xpath is a required argument"
        }
        options.fetch(:klass) {
          raise ArgumentError, ":klass is a required argument"
        }
        options.fetch(:type) {
          raise ArgumentError, ":type is a required argument"
        }
        associations[name] = options.freeze
        define_method(name, &block) if block_given?
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

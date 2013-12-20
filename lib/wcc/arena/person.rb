require 'wcc/arena/person_query'

module WCC::Arena

  class Person
    attr_reader :first_name, :last_name

    def initialize(attrs={})
      @first_name = attrs[:first_name]
      @last_name = attrs[:last_name]
    end

  end

end

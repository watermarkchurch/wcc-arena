require 'wcc/arena/person_attribute'

module WCC::Arena
  class PersonAttributeGroup
    include WCC::Arena::Mappers::XML

    attribute :id, xpath: "AttributeGroupID", type: :integer
    attribute :name, xpath: "AttributeGroupName"

    has_many :attributes, xpath: "Attributes/PersonAttribute", klass: PersonAttribute
  end
end

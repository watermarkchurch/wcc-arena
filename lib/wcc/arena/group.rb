require 'wcc/arena/group_query'

require 'wcc/arena/address'

module WCC::Arena
  class Group
    include WCC::Arena::Mappers::XML

    attribute :id, xpath: "GroupID", type: :integer
    attribute :guid, xpath: "Guid"

    attribute :name, xpath: "Name"
    attribute :area_name, xpath: "AreaName"
    attribute :area_id, xpath: "AreaID", type: :integer
    attribute :type, xpath: "GroupTypeValue"
    attribute :type_id, xpath: "GroupTypeID", type: :integer
    attribute :leader_id, xpath: "LeaderID", type: :integer

    has_one :address, xpath: "TargetLocation", klass: Address
  end
end

require 'wcc/arena/group_member_query'

require 'wcc/arena/person'

module WCC::Arena

  class GroupMember
    include WCC::Arena::Mappers::XML

    attribute :group_id, xpath: "GroupID", type: :integer
    attribute :person_id, xpath: "PersonID", type: :integer

    attribute :active, xpath: "Active", type: :boolean
    attribute :joined_at, xpath: "DateJoined", type: :time
    attribute :role, xpath: "RoleValue"
    attribute :role_id, xpath: "RoleID", type: :integer

    has_one :person, xpath: "PersonInformation", klass: Person
  end

end

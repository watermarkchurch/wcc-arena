require 'wcc/arena/profile_query'

module WCC::Arena

  class Profile
    include WCC::Arena::Mappers::XML

    attribute :id, xpath: "ProfileID", type: :integer
    attribute :guid, xpath: "Guid"

    attribute :name, xpath: "Name"
    attribute :title, xpath: "Title"
    attribute :summary, xpath: "Summary"
    attribute :type, xpath: "ProfileTypeValue"
    attribute :type_id, xpath: "ProfileTypeID", type: :integer
    attribute :active, xpath: "Active", type: :boolean
    attribute :parent_id, xpath: "ParentProfileID", type: :integer

    attribute :active_members, xpath: "ActiveMembers", type: :integer
    attribute :dormant_members, xpath: "DormantMembers", type: :integer
    attribute :total_members, xpath: "TotalMembers", type: :integer

    def children
      @children ||= ProfileQuery.new(parent_profile_id: id).()
    end
  end

end

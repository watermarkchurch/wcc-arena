require 'wcc/arena/person_query'

require 'wcc/arena/address'
require 'wcc/arena/email'
require 'wcc/arena/phone'

module WCC::Arena

  class Person
    include WCC::Arena::Mappers::XML

    attribute :id, xpath: "PersonID"
    attribute :guid, xpath: "PersonGUID"

    attribute :first_name, xpath: "FirstName"
    attribute :nick_name, xpath: "NickName"
    attribute :middle_name, xpath: "MiddleName"
    attribute :last_name, xpath: "LastName"
    attribute :full_name, xpath: "FullName"

    attribute :age, xpath: "Age"
    attribute :birth_date, xpath: "BirthDate"
    attribute :campus_name, xpath: "CampusName"
    attribute :family_id, xpath: "FamilyID"
    attribute :gender, xpath: "Gender"
    attribute :member_status_id, xpath: "MemberStatusID"
    attribute :member_status_value, xpath: "MemberStatusValue"
    attribute :status, xpath: "RecordStatusValue"

    attribute :home_phone, xpath: "HomePhone"
    attribute :business_phone, xpath: "BusinessPhone"
    attribute :cell_phone, xpath: "CellPhone"

    attribute :email, xpath: "FirstActiveEmail"

    alias :member_status :member_status_value

    has_many :addresses, xpath: "Addresses/Address", klass: Address
    has_many :emails, xpath: "Emails/Email", klass: Email
    has_many :phones, xpath: "Phones/Phone", klass: Phone
  end

end

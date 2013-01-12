class User
  include Mongoid::Document

  field :username, type: String
  has_many :projects
  has_many :object_defs

  store_in collection: "easyAPI.users"

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def create_object_definition(objectDefName, objectDefData)
    return ObjectDef.generate(objectDefName, objectDefData, self)
  end

  # TBD
  def destroy_object_definition(objectDefName)
    return ObjectDef.destroy_by_name(objectDefName, self)
  end

  # TBD
  def create_project(name)
    return Project.generate(name, self)
  end

  # TBD
  def echo_test
    puts "Hello world!"
  end
end

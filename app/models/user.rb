class User
  include Mongoid::Document

  field :username, type: String
  field :email, type: String
  field :session_token, type: String
  field :api_key, type: String

  has_many :projects
  has_many :object_defs

  store_in collection: USER_PATH

  before_create :set_api_key
  after_create :create_default_project

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def create_default_project
    self.create_project("My Project")
  end

  # TBD
  def set_api_key
    self.api_key = "123Key"
  end

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

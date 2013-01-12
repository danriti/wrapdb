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
    return ObjectDef.generate(objectDefName, objectDefData, self.username)
  end

  # TBD
  def destroy_object_definition(objectDefName)
    return ObjectDef.destroy_by_name(objectDefName, self.username)
  end

  # TBD
  def create_instance_document(objectDefName, instanceData, projectName)
    return Instance.generate(self.username, 
                             objectDefName, 
                             instanceData, 
                             projectName)
  end

  # TBD
  def get_instances_by_object_name(objectDefName)
    return Instance.get_all_by_name(objectDefName, username)
  end

  # TBD
  def echo_test
    puts "Hello world!"
  end
end

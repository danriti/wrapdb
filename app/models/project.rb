class Project
  include Mongoid::Document

  field :name, type: String

  belongs_to :user
  #has_many :endpoints
  has_many :instances

  store_in collection: "easyAPI.users.projects"

  #-----------------------------------------------------------------------------
  # Class methods
  #-----------------------------------------------------------------------------

  # TBD
  def self.generate(name, user)
    if user != nil
      project = Project.create!(:name => name,
                                :user => user)
      return project
    end
  end 

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def create_instance_document(objectDefName, instanceData)
    objectDef = ObjectDef.where(name: objectDefName).first
    return Instance.generate(objectDef, 
                             instanceData, 
                             self)
  end

  # TBD
  def get_instances_by_object_name(objectDefName)
    objectDef = ObjectDef.where(name: objectDefName).first
    return Instance.get_all_by_name(objectDef, self)
  end

  # TBD
  def self.destroy_by_name
    nil
  end 

  # TBD
  def self.get_by_name
    nil
  end 

  # TBD
  def self.get_all_endpoints
    nil
  end 
end

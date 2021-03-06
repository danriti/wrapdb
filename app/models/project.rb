class Project
  include Mongoid::Document

  field :name, type: String

  belongs_to :user
  has_many :endpoints
  has_many :instances

  index({name: 1, user_id: 1}, {unique: true})

  store_in collection: PROJECT_PATH

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

  # TBD
  def self.destroy_by_name
    nil
  end

  # TBD
  def self.get_by_name
    nil
  end

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def create_endpoint(endpointName, endpointData)
    return Endpoint.generate(endpointName, endpointData, self)
  end

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
  def get_all_endpoints
    return Endpoint.where(project: self)
  end

  # TBD
  def get_endpoint_by_name(name)
    return Endpoint.where(project: self, name: name).first
  end
end

class ObjectDef
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :username, type: String
  field :data, type: Array
  store_in collection: "easyAPI.users.objects"

  #-----------------------------------------------------------------------------
  # Class methods
  #-----------------------------------------------------------------------------

  # Generate a new object definition.
  def self.generate(objectDefName, objectDefData, username)
    obj = ObjectDef.create!(:name => objectDefName,
                            :type => "object",
                            :username => username,
                            :data => objectDefData)
    return obj
  end

  # Destroy object definition by name.
  def self.destroy_by_name(objectDefName, username)
    objectDef = ObjectDef.where(name: objectDefName).first

    # If the object definition exists and there are no instances associated with
    # the object definition, destroy the object destory.
    if objectDef != nil and 
       not Instance.where(objectDefId: objectDef.id, username: username).exists?
      ObjectDef.where(name: objectDefName, username: username).destroy
      return true
    else
      return false
    end
  end

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # Normalize data between an object definition and an instance.
  def normalize_instance(instanceData)
    instance = Hash.new

    self.data.each do |data|
      if data["type"] == "objectRef"
        instance.store(data["name"], {"$ref" => INSTANCE_PATH,
                                      "$id" => instanceData[data["name"]]})
      else
        instance.store(data["name"], instanceData[data["name"]])
      end
    end

    return instance
  end

end

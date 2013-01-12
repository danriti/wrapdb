class Instance
  include Mongoid::Document
  field :type, type: String
  field :username, type: String
  field :objectDefId, type: String
  field :projectName, type: String
  field :data, type: Hash
  store_in collection: "easyAPI.users.instances"

  #-----------------------------------------------------------------------------
  # Class methods
  #-----------------------------------------------------------------------------

  # TBD
  def self.get_all_by_name(objectDefName, username)
    id = ObjectDef.find_by(name: objectDefName, username: username).id

    outputArray = []

    if id != nil
      instances = self.where(username: username, objectDefId: id)

      instances.each do |i|
        outputArray.push({"id" => i.id,
                          "data" => i.data})
      end
    end

    return outputArray
  end

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def dereference(id, username)
    i = Instance.find_by(id: id)
  
    return i.render_instance(username)
  end

  # TBD
  def render_instance(username)
    objectDef = ObjectDef.find_by(id: self.objectDefId, username: username)

    returnHash = Hash.new

    objectDef.data.each do |objectDefData|
      if objectDefData["type"] == "objectRef"
        dbRef = self.data[objectDefData["name"]]
        returnHash.store(objectDefData["name"], dereference(dbRef["$id"], username))
      else
        returnHash.store(objectDefData["name"], self.data[objectDefData["name"]])
      end
    end

    return returnHash
  end
end

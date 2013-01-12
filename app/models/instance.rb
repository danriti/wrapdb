class Instance
  include Mongoid::Document
  field :type, type: String
  field :user, type: String
  field :object, type: String
  field :data, type: Hash
  store_in collection: "easyAPI.users.instances"

  def dereference(id, username)
    i = Instance.find_by(id: id)
  
    # Return
    i.render_instance(username)
  end

  def render_instance(username)
    objectDef = ObjectDef.find_by(id: self.object, user: username)

    returnHash = Hash.new

    objectDef.data.each do |objectDefData|
      if objectDefData["type"] == "objectRef"
        dbRef = self.data[objectDefData["name"]]
        returnHash.store(objectDefData["name"], dereference(dbRef["$id"], username))
      else
        returnHash.store(objectDefData["name"], self.data[objectDefData["name"]])
      end
    end

    # Return
    returnHash
  end
end

class Instance
  include Mongoid::Document

  field :type, type: String
  field :data, type: Hash

  belongs_to :object_def
  belongs_to :project

  store_in collection: INSTANCE_PATH

  #-----------------------------------------------------------------------------
  # Class methods
  #-----------------------------------------------------------------------------

  # TBD
  def self.generate(objectDef, instanceData, project)
    if objectDef == nil or project == nil
      return nil
    end

    instanceData = objectDef.normalize_instance(instanceData)

    instance = Instance.create!(:type => "instance",
                                :object_def => objectDef,
                                :data => instanceData,
                                :project => project)
    return instance
  end

  # TBD
  def self.get_all_by_name(objectDef, project)
    if objectDef == nil 
      return nil
    end

    outputArray = []

    instances = self.where(object_def: objectDef, project: project)

    instances.each do |i|
      outputArray.push({"id" => i.id,
                        "data" => i.data})
    end

    return outputArray
  end

  # TBD
  def self.render_all(objectDefId, project, selectionHash={})
    returnArray = Array.new

    instances = Instance.where(project: project, 
                               object_def_id: objectDefId)

    # Loop through each Mongoid instance and render!
    instances.each do |instance|
      returnArray.push(instance.render)
    end
        
    return returnArray
  end

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def dereference(id, level)
    if level > MAX_DEREFERENCE_NESTING_LEVEL
      return {"error" => "max nesting level"}
    end

    i = Instance.find_by(id: id)
    return i.render(level)
  end

  # TBD
  def render(level=0)
    if self.object_def == nil
      return nil
    end

    returnHash = Hash.new

    self.object_def.data.each do |objectDefData|
      if objectDefData["type"] == "objectRef"
        dbRef = self.data[objectDefData["name"]]
        returnHash.store(objectDefData["name"], 
                         dereference(dbRef["$id"], level+1))
      else
        returnHash.store(objectDefData["name"], 
                         self.data[objectDefData["name"]])
      end
    end

    return returnHash
  end
end

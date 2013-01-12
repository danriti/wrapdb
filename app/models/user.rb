class User < ActiveRecord::Base

  attr_accessible :image, :name, :provider, :uid, :username

  has_many :projects

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
  def create_instance_document(objectDefName, instanceData)
    objectDef = ObjectDef.find_by(name: objectDefName, username: self.username)
    id = objectDef.id

    instanceData = objectDef.normalize_instance(instanceData)

    if id != nil
      instance = Instance.new(:type => "instance",
                              :username => self.username,
                              :objectDefId => id,
                              :data => instanceData,
                              :project => nil)
      return instance.save
    end
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

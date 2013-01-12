class User < ActiveRecord::Base

  OBJECT_PATH = "easyAPI.users.objects"
  INSTANCE_PATH = "easyAPI.users.instances"  

  attr_accessible :image, :name, :provider, :uid, :username

  has_many :projects

  def create_object_document(objectName, objectData)
    obj = ObjectDef.new(:name => objectName,
                        :type => "object",
                        :user => username,
                        :data => objectData,
                        :project => nil)
    obj.save
  end

  def process_instance_data(objectDef, instanceData)
    instance = Hash.new

    objectDef.data.each do |data|
      if data["type"] == "objectRef"
        instance.store(data["name"], {"$ref" => INSTANCE_PATH,
                                      "$id" => instanceData[data["name"]]})
      else
        instance.store(data["name"], instanceData[data["name"]])
      end
    end

    instance
  end

  def create_instance_document(objectName, instanceData)
    objectDef = ObjectDef.find_by(name: objectName, user: username)
    id = objectDef.id

    instanceData = process_instance_data(objectDef, instanceData)

    if id != nil
      instance = Instance.new(:type => "instance",
                              :user => username,
                              :object => id,
                              :data => instanceData)
      instance.save
    end
  end

  def get_instance_by_object_name(objectName)
    id = ObjectDef.find_by(name: objectName, user: username).id

    outputArray = []

    if id != nil
      instances = Instance.where(user: username, object: id)

      instances.each do |i|
        outputArray.push({"id" => i.id,
                          "data" => i.data})
      end
    end

    # Return array of data hashes
    outputArray
  end

  def echo_test
    puts "Hello world!"
  end
end

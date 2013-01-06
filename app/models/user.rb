class User < ActiveRecord::Base

  OBJECT_PATH = "easyAPI.users.objects"
  INSTANCE_PATH = "easyAPI.users.instances"  

  attr_accessible :image, :name, :provider, :uid, :username

  has_many :projects

  def create_object_document(objectName, objectValue)
    #session = Moped::Session.new(["127.0.0.1:27017", "127.0.0.1:27018", "127.0.0.1:27019" ])
    #session.use :easy_api_development

    ## db.easyAPI.users.objects insert a new document!
    #userObjects = session[OBJECT_PATH]
    #userObjects.insert({"type" => "object",
    #                    "name" => objectName,
    #                    "user" => username,
    #                    "value" => objectValue})

    obj = ObjectDef.new(:name => objectName,
                        :type => "object",
                        :user => username,
                        :value => objectValue,
                        :project => nil)
    obj.save
  end

  def create_instance_document(objectName, instanceValue)
    id = ObjectDef.find_by(name: objectName, user: username).id

    if id != nil
      instance = Instance.new(:type => "instance",
                              :user => username,
                              :object => id,
                              :value => instanceValue)
      instance.save
    end
  end

  def echo_test
    puts "Hello world!"
  end
end

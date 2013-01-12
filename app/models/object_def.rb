class ObjectDef
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :user, type: String
  field :data, type: Array
  field :project, type: String
  store_in collection: "easyAPI.users.objects"
end

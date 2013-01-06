class Instance
  include Mongoid::Document
  field :type, type: String
  field :user, type: String
  field :object, type: String
  field :value, type: Hash
  store_in collection: "easyAPI.users.instances"
end

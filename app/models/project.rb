class Project
  include Mongoid::Document
  field :name, type: String
  #belongs_to :user
  #has_many :endpoints
  has_many :instances

  store_in collection: "easyAPI.users.projects"

  #-----------------------------------------------------------------------------
  # Class methods
  #-----------------------------------------------------------------------------

  # TBD
  def self.generate
    nil
  end 

  # TBD
  def self.destroy_by_name
    nil
  end 

  # TBD
  def self.get_by_name
    nil
  end 

  # TBD
  def self.get_all_endpoints
    nil
  end 
end

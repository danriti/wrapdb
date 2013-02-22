class Endpoint 
  include Mongoid::Document

  field :name, type: String
  field :type, type: String
  field :data, type: Array

  belongs_to :project

  store_in collection: ENDPOINT_PATH

  #-----------------------------------------------------------------------------
  # Class methods
  #-----------------------------------------------------------------------------

  # TBD
  def self.generate(endpointName, endpointData, project)
    if project == nil
      return nil
    end

    endpoint = Endpoint.create!(:name => endpointName,
                                :type => "endpoint",
                                :data => endpointData,
                                :project => project)

    return endpoint
  end

  #-----------------------------------------------------------------------------
  # Instance methods
  #-----------------------------------------------------------------------------

  # TBD
  def render(level=0, selectionHash)
    returnHash = Hash.new

    self.data.each do |endpointData|
      if endpointData["type"] == "objectRef"
        # Will be implemented with filtering/sorting!
        #selectionHash = selectionHash[endpointData["selectionName"]] 

        instanceArray = Instance.render_all(endpointData["objectId"],
                                            self.project,
                                            {})
        
        # Append instanceArray to the return hash.
        returnHash.store(endpointData["name"], instanceArray)
      else
        returnHash.store(endpointData["name"], 
                         endpointData["value"])
      end
    end 

    return returnHash
  end

end

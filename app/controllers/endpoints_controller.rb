class EndpointsController < ApplicationController
  # /:projectId/endpoints/create
  def create
    apiKey = params[:api_key]
    projectId = params[:projectId]
    endpointName = params[:name]
    endpointData = params[:data]

    # Get that user and handle not existant user.
    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    # Grab that project and handle not existant project.
    project = Project.where(id: projectId).first
    if not project
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_PROJECT_ID }, :callback => params[:callback]
    end

    # Create the project endpoint!
    endpoint = project.create_endpoint(endpointName, endpointData)
    
    return render :json => { 'id' => endpoint.id,
                             'url' => 'TBD',
                             'status' => 'success' }, :callback => params[:callback]
  end

  # /:projectId/endpoints/get
  def get
    apiKey = params[:api_key]
    projectId = params[:projectId]

    # Get that user and handle not existant user.
    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    # Grab that project and handle not existant project.
    project = Project.where(id: projectId).first
    if not project
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_PROJECT_ID }, :callback => params[:callback]
    end

    endpoints = project.get_all_endpoints

    # Check if the user project has any endpoints.
    if endpoints.any?
      return render :json => { 'endpoints' => endpoints,
                               'status' => 'success' }, :callback => params[:callback]
    else
      return render :json => { 'status' => 'fail',
                               'error' => NO_PROJECT_ENDPOINTS }, :callback => params[:callback]
    end
  end

  # /endpoints/render
  def get_adapter
    nil
  end

  # /endpoints/get
  def get_endpoints
    array = Endpoint.joins(:item).where(:items => { :keytype => 'blueprint' })

    render :json => array, :callback => params[:callback]
  end

  def create_instance_dictionary(item, blueprint, dictionary, data)
    blueprint.dictionary.tuples.each do |t|
      key = t.key
      keytype = t.item.keytype
      value = data[key]

      tuple = Tuple.new(:key => key)
      tuple.dictionary = dictionary

      if keytype == 'string'
        new_item = create_item(value, 'string')
        tuple.item = new_item
        tuple.save
      elsif keytype == 'dictionary'
        d = Dictionary.create!

        new_item = create_item(nil, 'dictionary')
        new_item.dictionary = d
        new_item.save
        tuple.item = new_item
        tuple.save

        create_instance_dictionary(new_item, t.item, d, data[key])
      elsif keytype == 'array'
        array = t.item.erray

        e = Erray.create!

        new_item = create_item(nil, 'array')
        new_item.erray = e
        new_item.save
        tuple.item = new_item
        tuple.save

        arrays = data[key]

        arrays.each do |a|
          new_tuple = Tuple.new(:key => nil)
          new_tuple.erray = e
          
          new_item = create_item(a, 'string')
          new_tuple.item = new_item
          new_tuple.save
        end
      end
    end
  end

  # /endpoints/instance/create
  def create_instance
    #endpoint = Endpoint.where(:id => params[:endpointid]).first
    blueprint = Item.where(:name => params[:blueprintname]).first

    data = JSON.parse(params[:data])

    puts 'HASH HERE!'
    puts data

    d = Dictionary.create!
    #create_dictionary(item, blob)

    item = Item.new(:name => nil,
                    :keytype => 'instance')
    item.blueprint = blueprint
    item.dictionary = d
    item.save

    if blueprint != nil
      create_instance_dictionary(item, blueprint, d, data)

      render :json => { 'id' => item.id, 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end

  # /endpoints/instance/get
  def create_get
    nil
  end

  # /endpoints/render
  def get_render
    endpoint = Endpoint.where(:id => params[:id]).first
    
    if endpoint != nil
      h = Hash.new
      h = construct_dictionary(endpoint.item, h)

      render :json => h
    else
      render :json => { 'status' => 'fail' }
    end
  end

  # /test
  def test
    render :json => {"status" => "success"}
  end

  # /test/body
  # This tests the fetching of POST request parameters.
  def test_body
    blob = JSON.parse(params[:blob])

    d = Dictionary.create!

    render :json => blob
  end

private

  def create_item(value, keytype)
    Item.create!(:value => value,
                 :keytype => keytype)
  end

  def create_array(item, blob)
    e = Erray.create!

    item.erray = e
    item.save

    tuple = Tuple.new(:key => nil)
    tuple.erray = e

    blob['value'].each do |i|
      type = i['type']
      value = i['value']

      if type == 'value'
        puts 'Value => ' + value

        new_item = create_item(value, 'string')
        new_item.save

        tuple.item = new_item
        tuple.save
  
      elsif type == 'dictionary'
        puts 'Type: ' + type
        
        new_item = create_item(nil, 'dictionary')
        tuple.item = new_item
        tuple.save

        create_dictionary(new_item, i) 

      elsif type == 'array'
        puts 'Type: ' + type
        
        new_item = create_item(nil, 'array')
        tuple.item = new_item
        tuple.save

        create_array(new_item, i)
      end
    end
  end 

  # Create a dictionary and all its children in the db.
  def create_dictionary(item, blob)
    d = Dictionary.create!

    item.dictionary = d
    item.save

    blob['value'].each do |i|
      type = i['type']
      key = i['key']
      value = i['value']

      tuple = Tuple.new(:key => key)
      tuple.dictionary = d

      # Tuple
      if type == 'tuple'
        puts 'Type: ' + type + ' => { ' + key + ' : ' + value + ' }'

        new_item = create_item(value, 'string')
        tuple.item = new_item
        tuple.save
  
      # Dictionary
      elsif type == 'dictionary'
        puts 'Type: ' + type
        
        new_item = create_item(nil, 'dictionary')
        tuple.item = new_item
        tuple.save

        create_dictionary(new_item, i) 

      # Array
      elsif type == 'array'
        puts 'Type: ' + type
        
        new_item = create_item(nil, 'array')
        tuple.item = new_item
        tuple.save

        create_array(new_item, i)
  
      # Blueprint
      elsif type == 'blueprint'
        puts 'Type: ' + type

        new_item = create_item(nil, 'blueprint')
        tuple.item = new_item
        tuple.save

      end
    end
  end

  def construct_array(item, array)
    # Loop through each endpoint tuple.
    item.erray.tuples.each do |tuple|
      keytype = tuple.item.keytype
      value = tuple.item.value
    
      puts 'Construct Value: ' + value
      
      if keytype == 'string'
        array << value
      elsif keytype == 'dictionary'
        h = Hash.new
        value = construct_dictionary(i, h)
        array << value
      elsif keytype == 'array'
        a = Array.new
        value = construct_array(i, a)
        array << value
      end
    end
  end
  
  def construct_blueprint(item, array, blueprintkey)
    blueprint = Item.where(:keytype => 'blueprint', :name => blueprintkey).first    

    instances = Item.where(:blueprint_id => blueprint.id)

    #array << instances.first.dictionary.tuples.first.item.value
    #array << item
  
    instances.each do |i|
      h = Hash.new

      h = construct_dictionary(i, h)
    
      puts 'INSTANCE!!!'
      puts i.dictionary.tuples.size
      
      array << h
    end

    # Loop through each blueprint tuple.
    #item.dictionary.tuples.each do |tuple|
    #  keytype = tuple.item.keytype
    #  
    #  if keytype == 'string'
    #    key = tuple.key
    #    value = tuple.item.value
    #    hash.store(key, value)
    #  elsif keytype == 'dictionary'
    #    key = tuple.key
    #    h = Hash.new
    #    value = construct_dictionary(tuple.item, h)
    #    hash.store(key, h)
    #  elsif keytype == 'array'
    #    key = tuple.key
    #    a = Array.new
    #    value = construct_array(tuple.item, a)
    #    hash.store(key, a)
    #  elsif keytype == 'blueprint'
    #    key = tuple.key
    #    h = Hash.new
    #    value = construct_dictionary(tuple.item, h)
    #    hash.store(key, h)
    #  end
    #end

    array
  end

  def construct_dictionary(item, hash)
    # Loop through each endpoint tuple.
    item.dictionary.tuples.each do |tuple|
      keytype = tuple.item.keytype
      puts 'keytype: ' + keytype
      
      if keytype == 'string'
        key = tuple.key
        value = tuple.item.value
        hash.store(key, value)
      elsif keytype == 'dictionary'
        key = tuple.key
        h = Hash.new
        value = construct_dictionary(tuple.item, h)
        hash.store(key, h)
      elsif keytype == 'array'
        puts 'construct_dictionary#array'
        key = tuple.key
        a = Array.new
        value = construct_array(tuple.item, a)
        hash.store(key, a)
      elsif keytype == 'blueprint'
        key = tuple.key
        a = Array.new
        value = construct_blueprint(tuple.item, a, key)
        hash.store(key, a)
      end
    end

    hash
  end

end

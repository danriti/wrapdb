class EndpointsController < ApplicationController
  # /endpoints/create
  def create
    project = Project.where(:id => params[:projectid]).first
    
    if project != nil
      blob = JSON.parse(params[:blob])

      item = Item.new(:name => blob['key'],
                      :keytype => blob['type'].downcase)
      item.save

      endpoint = Endpoint.new(:name => params[:name])
      endpoint.project = project
      endpoint.item = item
      endpoint.save

      create_dictionary(item, blob)

      render :json => { 'id' => endpoint.id, 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end

  # /endpoints/render
  def get_adapter
    nil
  end

  def create_instance_dictionary
    nil
  end

  # /endpoints/instance/create
  def create_instance
    #endpoint = Endpoint.where(:id => params[:endpointid]).first
    blueprint = Item.where(:name => params[:blueprintname]).first

    d = Dictionary.create!
    #create_dictionary(item, blob)

    item = Item.new(:name => nil,
                    :keytype => 'instance')
    item.blueprint = blueprint
    item.dictionary = d
    item.save

    if blueprint != nil
      blueprint.dictionary.tuples.each do |t|
        data = JSON.parse(params[:data])
        key = t.key
        keytype = t.item.keytype
        value = data[key]

        if keytype == 'string'
          tuple = Tuple.new(:key => key)
          tuple.dictionary = d

          new_item = create_item(value, 'string')
          tuple.item = new_item
          tuple.save
        elsif keytype == 'dictionary'
          new_item = create_item(nil, 'dictionary')
          tuple.item = new_item
          tuple.save

          create_instance(new_item, i) 

        end
      end

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


  # /test/body
  # This tests the fetching of POST request parameters.
  def test
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

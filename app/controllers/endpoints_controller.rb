class EndpointsController < ApplicationController
  # /endpoints/create
  def create
    project = Project.where(:id => params[:projectid]).first
    
    if project != nil
      d = Dictionary.create!

      endpoint = Endpoint.new(:name => params[:name])
      endpoint.project = project
      endpoint.dictionary = d
      endpoint.save
      
      blob = JSON.parse(params[:blob])

      first_function(blob, d)

      render :json => { 'id' => endpoint.id, 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end

  # /endpoints/render
  def get_render
    endpoint = Endpoint.where(:id => params[:id]).first
    
    if endpoint != nil
      h = Hash.new
      h = second_function(endpoint.dictionary, h)

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
    first_function(blob, d)

    render :json => blob
  end

private

  # Do something else cool.
  def second_function(dictionary, hash)
    # Loop through each endpoint tuple.
    dictionary.tuples.each do |tuple|
      keytype = tuple.item.keytype
      
      if keytype == 'string'
        key = tuple.key
        value = tuple.item.value
        hash.store(key, value)
      elsif keytype == 'dictionary'
        key = tuple.key
        h = Hash.new
        value = second_function(tuple.item.dictionary, h)
        hash.store(key, h)
      elsif keytype == 'array'
        nil
      end
    end

    hash
  end

  # Do something cool.
  def first_function(blob, dictionary)
    # Create top level item.
    i = Item.new(:name => blob['key'],
                 :keytype => blob['type'].downcase)
    i.dictionary = dictionary
    i.save

    blob['value'].each do |i|
      type = i['type']
      key = i['key']
      value = i['value']

      # Tuple
      if type == 'tuple'
        puts 'Type: ' + type + ' => { ' + key + ' : ' + value + ' }'

        item = Item.create!(:value => value,
                            :keytype => 'string')
  
        tuple = Tuple.new(:key => key)
        tuple.dictionary = dictionary
        tuple.item = item
        tuple.save

      # Dictionary
      elsif type == 'dictionary'
        puts 'Type: ' + type
        
        d = Dictionary.create!

        item = Item.new(:value => nil,
                        :keytype => 'dictionary')
        item.dictionary = d
        item.save
  
        tuple = Tuple.new(:key => key)
        tuple.dictionary = dictionary
        tuple.item = item
        tuple.save

        # Get recursive and digest the dictionary.
        first_function(i, d)

      # Array
      elsif type == 'array'
        puts 'Type: ' + type
      end
    end
  end

end

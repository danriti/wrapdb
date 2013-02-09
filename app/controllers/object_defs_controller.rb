class ObjectDefsController < ApplicationController
  # /objects/create
  def create
    apiKey = params[:api_key]

    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    # Grab the ObjectDef name and data from the params.
    objectDefName = params[:name]
    objectDefData = params[:data]

    objectDef = user.create_object_definition(objectDefName, objectDefData)

    return render :json => { 'id' => objectDef.id,
                             'status' => 'success' }, :callback => params[:callback]
  end

  # /objects/get
  def get
    apiKey = params[:api_key]

    # Get the user and handle an invalid api key.
    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    objectDefs = ObjectDef.where(user: user)

    # Check if the user has any projects.
    if objectDefs.any?
      return render :json => { 'objects' => objectDefs,
                               'status' => 'success' }, :callback => params[:callback]
    else
      return render :json => { 'status' => 'fail',
                               'error' => NO_USER_OBJECTS }, :callback => params[:callback]
    end
  end

end

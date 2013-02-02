class ObjectDefsController < ApplicationController
  def create
    apiKey = params[:api_key]

    user = User.where(api_key: params[:api_key]).first
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
end

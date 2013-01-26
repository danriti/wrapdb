class ObjectDefsController < ApplicationController
  def create
    apiKey = params[:api_key]

    user = User.where(api_key: params[:api_key]).first

    if user
      # Grab the ObjectDef name and data from the params.
      objectDefName = params[:name]
      objectDefData = params[:data]

      objectDef = user.create_object_definition(objectDefName, objectDefData)

      render :json => { 'id' => objectDef.id,
                        'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'success' }, :callback => params[:callback]
    end
  end
end

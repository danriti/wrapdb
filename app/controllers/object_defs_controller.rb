class ObjectDefsController < ApplicationController
  def create
    user = User.where(:api_key => params[:api_key]).first

    if user
      # Grab the ObjectDef name and data from the params.
      objectDefName = params[:name]
      objectDefData = params[:data]

      user.create_object_definition(objectDefName, objectDefData)

      # Create ObjectDef route
      # ...

      render :json => { 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'success' }, :callback => params[:callback]
    end
  end
end

class ObjectDefsController < ApplicationController
  def create
    username = params[:username]
    user = User.where(username: username).first
    
    if user 
      objectDefName = params[:name]
      
      # Grab the ObjectDef from the body!
      # puts "DATA!!!"
      # puts params[:data]
      objectDef = params[:data]

      user.create_object_definition(objectDefName, objectDef)
      
      # Create ObjectDef route
      
      render :json => { 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'success' }, :callback => params[:callback]
    end
  end
end

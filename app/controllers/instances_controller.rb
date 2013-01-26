class InstancesController < ApplicationController
  def insert
    apiKey = params[:api_key]
    projectId = params[:projectId]
    objectDefName = params[:objectDefName].downcase
    instanceData = params[:data]

    user = User.where(api_key: apiKey).first
    project = Project.where(user: user, id: projectId).first

    if project
      instance = project.create_instance_document(objectDefName, instanceData)

      render :json => { 'id' => instance.id,
                        'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end
end

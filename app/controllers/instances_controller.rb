class InstancesController < ApplicationController
  def insert
    apiKey = params[:api_key]
    projectId = params[:projectId]
    objectDefName = params[:objectDefName].downcase
    instanceData = params[:data]

    # Get that user and handle not existant user.
    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    # Grab that project and handle not existant project.
    project = Project.where(user: user, id: projectId).first
    if not project
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_PROJECT_ID }, :callback => params[:callback]
    end

    # Everything's good in the hood, so create the instance!
    instance = project.create_instance_document(objectDefName, instanceData)

    return render :json => { 'id' => instance.id,
                             'status' => 'success' }, :callback => params[:callback]
  end
end

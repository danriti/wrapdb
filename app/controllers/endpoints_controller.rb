class EndpointsController < ApplicationController
  # /endpoints/create
  def create
    project = Project.where(:id => params[:projectid]).first
    
    if project != nil
      endpoint = Endpoint.new(:name => params[:name])
      endpoint.project = project
      endpoint.save

      render :json => { 'id' => endpoint.id, 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end
end

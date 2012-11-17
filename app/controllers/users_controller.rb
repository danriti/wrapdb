class UsersController < ApplicationController
  # /users/create
  def create
    user = User.create!(:name => params[:name])

    if user != nil
      render :json => { 'id' => user.id, 'status' => 'success' }, :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end

  # /users/get
  def get
    user = User.where(:name => params[:name]).first

    if user != nil
      render :json => { 'user' => user, 
                        'projects' => user.projects,
                        'status' => 'success' }, 
             :callback => params[:callback]
    else
      render :json => { 'status' => 'fail' }, :callback => params[:callback]
    end
  end

end

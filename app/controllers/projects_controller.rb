class ProjectsController < ApplicationController
  # /projects/create
  def create
    apiKey = params[:api_key]
    projectName = params[:name]

    # Get the user and handle an invalid api key.
    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    # Create a new user project.
    project = user.create_project(projectName)

    return render :json => { 'id' => project.id,
                             'status' => 'success' }, :callback => params[:callback]

  end

  # /projects/get
  def get
    apiKey = params[:api_key]

    # Get the user and handle an invalid api key.
    user = User.where(api_key: apiKey).first
    if not user
      return render :json => { 'status' => 'fail',
                               'error' => INVALID_API_KEY }, :callback => params[:callback]
    end

    projects = Project.where(user: user)

    # Check if the user has any projects.
    if projects.any?
      return render :json => { 'projects' => projects,
                               'status' => 'success' }, :callback => params[:callback]
    else
      return render :json => { 'status' => 'fail',
                               'error' => NO_USER_PROJECTS }, :callback => params[:callback]
    end
  end

  def index
    render :json => { 'test' => 'Hello World' }
  end

#  # GET /projects
#  # GET /projects.json
#  def index
#    @projects = Project.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @projects }
#    end
#  end
#
#  # GET /projects/1
#  # GET /projects/1.json
#  def show
#    @project = Project.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @project }
#    end
#  end
#
#  # GET /projects/new
#  # GET /projects/new.json
#  def new
#    @project = Project.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @project }
#    end
#  end
#
#  # GET /projects/1/edit
#  def edit
#    @project = Project.find(params[:id])
#  end
#
#  # POST /projects
#  # POST /projects.json
#  def create
#    @project = Project.new(params[:project])
#
#    respond_to do |format|
#      if @project.save
#        format.html { redirect_to @project, notice: 'Project was successfully created.' }
#        format.json { render json: @project, status: :created, location: @project }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @project.errors, status: :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /projects/1
#  # PUT /projects/1.json
#  def update
#    @project = Project.find(params[:id])
#
#    respond_to do |format|
#      if @project.update_attributes(params[:project])
#        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @project.errors, status: :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /projects/1
#  # DELETE /projects/1.json
#  def destroy
#    @project = Project.find(params[:id])
#    @project.destroy
#
#    respond_to do |format|
#      format.html { redirect_to projects_url }
#      format.json { head :no_content }
#    end
#  end
end

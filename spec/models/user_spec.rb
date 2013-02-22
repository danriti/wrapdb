require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :username => "seneca",
      :email => "seneca@romanrepublic.com"
    }
    @u = User.create!(@attr) 
  end

  it "should fetch a user with the correct data" do
    u = User.where(username: "seneca").first
    u.email.should eql "seneca@romanrepublic.com"
    u.api_key.should eql "123Key"
  end

  it "should create a project" do
    p = @u.projects.first
    p.name.should eql "My Project"
  end

  it "should create an object def" do
    b = [{"name" => "name", "type" => "string"}, 
       {"name" => "address", "type" => "string"}]                                           
    @u.create_object_definition("business", b)
    
    @name = ObjectDef.find_by(name: "business").name
  end

  it "should destroy an object def" do
    @u.destroy_object_definition(@name)
  end     
end 

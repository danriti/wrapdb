require 'spec_helper'

describe "Endpoint creation" do

  before(:each) do
    @attr = {
      :username => "seneca",
      :email => "seneca@romanrepublic.com"
    }
  end

  it 'should create a project, objectdefs and endpoint' do
    u = User.create!(@attr)
    # Create a project.  
    p = u.projects.first
    # Create a business object document. 
    b = [{"name" => "name", "type" => "string"}, 
         {"name" => "address", "type" => "string"}]

    u.create_object_definition("business", b) 
    
    id = ObjectDef.find_by(name: "business").id  
    # Create a restroom object document. 
    r = [{"name" => "name", "type" => "string"}, 
         {"name" => "location", "type" => "string"}, 
         {"name" => "business", "type" => "objectRef", "objectId" => id}]
    rDef = u.create_object_definition("restroom", r)
    # Create a cat object document.  
    b = [{"name" => "name", "type" => "string"}, 
       {"name" => "breed", "type" => "string"}]                                           
    u.create_object_definition("cat", b)
   
    # Create first business instance.
    b1 = {"name" => "McDonalds", 
          "address" => "123 Happy Meal St"}
    p.create_instance_document("business", b1)             

    # Create second business instance.
    b1 = {"name" => "CVS", "address" => "123 Pharmacy St"}
    p.create_instance_document("business", b1)

    # Create third business instance.
    b1 = {"name" => "Pizza Joint", "address" => "123 Pepperoni St"}
    p.create_instance_document("business", b1)

    # Find the business you want to use!
    mcdonalds = p.get_instances_by_object_name("business")[0]
    cvs = p.get_instances_by_object_name("business")[1]

    # Create a restroom instance and reference a business! DUN DUN DUN!
    ri = {"name" => "McDonalds Bathroom",
          "location" => "2nd Floor",
          "business" => mcdonalds["id"]}
    p.create_instance_document("restroom", ri)

    # Create a restroom instance and reference a business! DUN DUN DUN!
    ri2 = {"name" => "CVS Bathroom",
           "location" => "1st Floor",
           "business" => cvs["id"]}
    p.create_instance_document("restroom", ri2)

    # Grab all instances of the restroom.
    instanceArray = p.get_instances_by_object_name("restroom")

    # Get the instance object.
    instance = Instance.find_by(id: instanceArray[0]["id"])

    # Test that business does NOT get destroyed because it contains instances.
    u.destroy_object_definition("business").should_not

    # Test that cats does NOT get destroyed because it does not exist.
    u.destroy_object_definition("cats").should_not

    # Test that cat DOES get destroyed because it contains no instances.
    u.destroy_object_definition("cat").should_not

     # Create an endpoint for displaying Bathrooms!
    e1 = [                          
           {                              
                "name" => "title",           
                "type" => "string",          
                "value" => "MyBathrooms"     
           },                             
           {                              
                "name" => "bathrooms",       
                "type" => "objectRef",       
                "objectId" => rDef.id,
                "selectionName" => "bathroomSelect"
           }                              
         ]
    e = p.create_endpoint("Bathroom List", e1)

    # Test the endpoint
    e.name.should eql "Bathroom List"
    e.type.should eql "endpoint" 
  end
end    

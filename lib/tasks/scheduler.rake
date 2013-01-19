desc "Insert test data into the database"
task :test_data => :environment do
  puts "Test Data!"

  # Remove all model instances.
  Item.destroy_all
  Tuple.destroy_all
  Dictionary.destroy_all
  Endpoint.destroy_all
  Project.destroy_all
  User.destroy_all

  u = User.create!(:name => 'Bob')

  p = Project.new(:name => 'Krapp')
  p.user = u
  p.save

  #e = Endpoint.new(:name => 'GetBathroom')
  #e.project = p
  #e.save

#  d = Dictionary.create!
#
#  # Create top level blueprint item
#  bbp = Item.new(:name => 'bathroom',
#                 :keytype => 'blueprint')
#  bbp.dictionary = d
#  bbp.save
#
#  # Specifying the blueprint.
#  i1 = Item.create!(:keytype => 'string')
#
#  t1 = Tuple.new(:key => 'name')
#  t1.dictionary = d
#  t1.item = i1
#  t1.save
#
#  i2 = Item.create!(:keytype => 'string')
#
#  t2 = Tuple.new(:key => 'location')
#  t2.dictionary = d
#  t2.item = i2
#  t2.save
#
#  di = Dictionary.create!
#
#  #
#  # Create bathroom instance.
#  #
#  bi1 = Item.new(:keytype => 'instance')
#  bi1.dictionary = di
#  bi1.blueprint = bbp
#  bi1.save
#
#  ni1 = Item.create!(:value => 'NERD',
#                     :keytype => 'string')
#  
#  nt1 = Tuple.new(:key => 'name')
#  nt1.dictionary = di
#  nt1.item = ni1
#  nt1.save
#
#  ni2 = Item.create!(:value => 'Boston',
#                     :keytype => 'string')
#  
#  nt2 = Tuple.new(:key => 'location')
#  nt2.dictionary = di
#  nt2.item = ni2
#  nt2.save
#
#  di2 = Dictionary.create!
#
#  bi2 = Item.new(:keytype => 'instance')
#  bi2.dictionary = di2
#  bi2.blueprint = bbp
#  bi2.save
#
#  ni3 = Item.create!(:value => 'JWU',
#                     :keytype => 'string')
#  
#  nt3 = Tuple.new(:key => 'name')
#  nt3.dictionary = di2
#  nt3.item = ni3
#  nt3.save
#
#  ni4 = Item.create!(:value => 'Providence',
#                     :keytype => 'string')
#  
#  nt4 = Tuple.new(:key => 'location')
#  nt4.dictionary = di2
#  nt4.item = ni4
#  nt4.save
#
#  #
#  # Example output
#  #
#  x = Item.where(:blueprint_id => bbp.id)
#
#  x.each do |x|
#    x.dictionary.tuples.each do |y|
#      puts y.key + ' : ' + y.item.value
#    end
#  end 

end

task :create_admin_user, [:username, :email] => [:environment] do |t, args|
  u = User.create!(:username => args[:username],
                   :email => args[:email])
end

task :mongo_test => :environment do

  User.destroy_all
  ObjectDef.destroy_all
  Instance.destroy_all
  Project.destroy_all

  # Create an admin user!
  Rake::Task['create_admin_user'].execute({:username => 'admin',
                                           :email => 'dmriti@gmail.com'})

  # Fetch the user and test it!
  u = User.first
  puts u.username == "admin"
  puts u.email == "dmriti@gmail.com"
  puts u.api_key == "123Key"

  # Create a project.
  p = u.projects.first
  puts p.name == "My Project"

  # Create a business object document.
  b = [{"name" => "name", "type" => "string"}, 
       {"name" => "address", "type" => "string"}]                                           
  u.create_object_definition("business", b)

  id = ObjectDef.find_by(name: "business").id

  # Create a restroom object document.
  r = [{"name" => "name", "type" => "string"}, 
       {"name" => "location", "type" => "string"}, 
       {"name" => "business", "type" => "objectRef", "objectId" => id}]
  u.create_object_definition("restroom", r)

  # Create a cat object document.
  b = [{"name" => "name", "type" => "string"}, 
       {"name" => "breed", "type" => "string"}]                                           
  u.create_object_definition("cat", b)

  # Example instance data!
  #   {
  #    "type" => "instance",
  #    "user" => "deepak"
  #    "object" => "business",
  #    "value" => {"name" => "McDonalds",
  #                "address" => "123 Happy Meal St"}
  #   }

  # Create first business instance.
  b1 = {"name" => "McDonalds", "address" => "123 Happy Meal St"}
  p.create_instance_document("business", b1)

  # Create second business instance.
  b1 = {"name" => "CVS", "address" => "123 Pharmacy St"}
  p.create_instance_document("business", b1)

  # Create third business instance.
  b1 = {"name" => "Pizza Joint", "address" => "123 Pepperoni St"}
  p.create_instance_document("business", b1)

  # Find the business you want to use!
  mcdonalds = p.get_instances_by_object_name("business")[0]

  # Create a restroom instance and reference a business! DUN DUN DUN!
  r = {"name" => "JWU Can",
       "location" => "2nd Floor",
       "business" => mcdonalds["id"]}
  p.create_instance_document("restroom", r)

  # Grab all instances of the restroom.
  instanceArray = p.get_instances_by_object_name("restroom")

  # Get the instance object.
  instance = Instance.find_by(id: instanceArray[0]["id"])

  # Print JSON with a reference to console!
  puts instance.render_instance

  # Test that business does NOT get destroyed because it contains instances.
  puts u.destroy_object_definition("business") == false

  # Test that cats does NOT get destroyed because it does not exist.
  puts u.destroy_object_definition("cats") == false

  # Test that cat DOES get destroyed because it contains no instances.
  puts u.destroy_object_definition("cat") == true
end

desc "TBD"
task :update_matches => :environment do
  puts "Update Matches!"

end

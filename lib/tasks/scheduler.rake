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

desc "TBD"
task :update_matches => :environment do
  puts "Update Matches!"

end

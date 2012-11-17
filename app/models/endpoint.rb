class Endpoint < ActiveRecord::Base
  belongs_to :project
  belongs_to :dictionary
  attr_accessible :name
end

class Endpoint < ActiveRecord::Base
  belongs_to :project
  belongs_to :item
  attr_accessible :name
end

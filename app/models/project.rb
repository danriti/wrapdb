class Project < ActiveRecord::Base
  belongs_to :user
  has_many :endpoints
  attr_accessible :name
end

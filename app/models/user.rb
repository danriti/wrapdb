class User < ActiveRecord::Base
  attr_accessible :image, :name, :provider, :uid

  has_many :projects
end

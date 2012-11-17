class Dictionary < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :endpoint
  has_many :tuples
end

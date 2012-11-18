class Dictionary < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :item
  has_many :tuples
end

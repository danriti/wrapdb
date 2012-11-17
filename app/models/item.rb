class Item < ActiveRecord::Base
  belongs_to :dictionary
  belongs_to :erray
  has_one :tuple
  attr_accessible :keytype, :name, :value
end

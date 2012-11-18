class Item < ActiveRecord::Base
  belongs_to :dictionary
  belongs_to :erray
  belongs_to :blueprint, :class_name => 'Item'
  has_one :tuple
  attr_accessible :keytype, :name, :value
end

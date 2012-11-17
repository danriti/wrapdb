class Tuple < ActiveRecord::Base
  belongs_to :dictionary
  belongs_to :item
  attr_accessible :key
end

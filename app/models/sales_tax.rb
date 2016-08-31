class SalesTax < ActiveRecord::Base
  belongs_to :kennel

  validates_numericality_of :percentage
end

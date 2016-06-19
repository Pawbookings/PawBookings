class User < ActiveRecord::Base
  has_one :kennel

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

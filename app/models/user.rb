class User < ActiveRecord::Base
  has_many :kennels

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

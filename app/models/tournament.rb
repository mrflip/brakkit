class Tournament < ActiveRecord::Base
  attr_accessible :name, :description, :user, :state
end

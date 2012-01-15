class Tournament < ActiveRecord::Base
  attr_accessible :name, :description, :user_id, :state
end

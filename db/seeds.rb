# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

class Hash
  # Create a hash from an array of keys and corresponding values.
  def self.zip(keys, values, default=nil, &block)
    hash = block_given? ? Hash.new(&block) : Hash.new(default)
    keys.zip(values){|key,val| hash[key]=val }
    hash
  end
end

class Array
  def random
    self[Kernel.rand(size)]
  end
end

USER_FIELDS = [:username, :email, :fullname, :url, :description]
File.open(File.join(Rails.root,"/db/seeds/users.tsv")) do |seed_file|
  seed_file.each do |line|
    values = line.strip.split("\t")
    uid    = values.shift
    fields = Hash.zip(USER_FIELDS, values)
    fields.each_key{|key| fields[key] = fields[key].to_s.strip }
    fields.merge! :password => 'foobar', :password_confirmation => 'foobar'
    u = User.find_or_create_by_id(uid)
    u.update_attributes fields
  end
end

# RESTAURANT_FIELDS = [:tags, :name, :url, :menu_url, :review_url, :phone, :note]
# File.open(File.join(Rails.root,"/db/seeds/restaurants.tsv")) do |seed_file|
#   seed_file.each do |line|
#     values = line.strip.split("\t").map(&:strip)
#     fields = Hash.zip(RESTAURANT_FIELDS, values)
#     fields[:delivers] = (fields[:note].to_s =~ /^(no\W*)/i ? nil : true )
#     fields[:note] = fields[:note].to_s.gsub(/^(no|yes)\W*/i,"")
#     r = Restaurant.find_or_create_by_name fields[:name]
#     r.update_attributes fields
#   end
# end

# all_restaurants = Restaurant.all.to_a
# (-2 .. 10).each do |offset|
#   meal = Meal.for_date(Date.today + offset)
#   if (rand(10) <= 5)
#     r = all_restaurants.random
#     meal.restaurant = r
#     meal.save!
#   end
# end
#
# all_users  = User.all.to_a
# Meal.all.each do |meal|
#   (3 + rand(3)).times do
#     user = all_users.random
#     order = Order.find_or_create_by_meal_id_and_user_id(meal.id, user.id)
#     order.description = %w[dog cat horse pig elephant].random
#     order.price       = 6.50 + rand(5.0)
#     order.save!
#   end
# end

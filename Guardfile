# -*- ruby -*-

#
# Reload the browser page on save
#
guard 'livereload' do
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/(models|controllers|helpers)/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.s[ac]ss})    {|m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee})      {|m| m[1] }
  watch(%r{config/locales/.+\.yml})
end

#
# Restart spork if any of the following change
#
guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch(%r{^spec/fabricators/.+\.rb$}){ :rspec }
  watch('spec/spec_helper.rb'){         :rspec }
  watch('test/test_helper.rb'){         :test_unit }
  watch(%r{features/support/}){         :cucumber }
end

#
# watch the app and test files, run spec if they change
#
guard('rspec', :version => 2,
  :cli => "--color --format nested --drb",
  :all_on_start => false, :all_after_pass => false,     ) do

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           {|m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 {|m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  {|m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          {|m| "spec/requests/#{m[1]}_spec.rb" }
end

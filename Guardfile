notification :growl

guard 'rspec', cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/sim/(.+)\.rb$})       { |m| "spec/models/sim_#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')        { "spec" }

  watch(%r{^spec/support/(.+)\.rb$})  { "spec" }
end

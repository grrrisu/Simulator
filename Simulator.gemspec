# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: Simulator 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "Simulator"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alessandro Di Maria"]
  s.date = "2014-08-29"
  s.description = "A simulation container based on Celluloid"
  s.email = "adm@m42.ch"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".ruby-version",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "Simulator.gemspec",
    "lib/ext/hash_ext.rb",
    "lib/level.yml",
    "lib/main.rb",
    "lib/sim.rb",
    "lib/sim/buildable.rb",
    "lib/sim/field_properties.rb",
    "lib/sim/level.rb",
    "lib/sim/matrix.rb",
    "lib/sim/net/message_dispatcher.rb",
    "lib/sim/net/message_serializer.rb",
    "lib/sim/net/parent_connection.rb",
    "lib/sim/net/player_connection.rb",
    "lib/sim/net/player_proxy.rb",
    "lib/sim/net/player_server.rb",
    "lib/sim/net/remote_exception.rb",
    "lib/sim/net/sub_process.rb",
    "lib/sim/object.rb",
    "lib/sim/player.rb",
    "lib/sim/queue/action_event.rb",
    "lib/sim/queue/event.rb",
    "lib/sim/queue/event_queue.rb",
    "lib/sim/queue/fire_worker.rb",
    "lib/sim/queue/master.rb",
    "lib/sim/queue/sim_event.rb",
    "lib/sim/queue/sim_loop.rb",
    "lib/sim/queue/test.rb",
    "lib/sim/time_unit.rb",
    "lib/sim/version.rb",
    "log/.gitkeep",
    "spec/integrations/player_server_spec.rb",
    "spec/integrations/popen_spec.rb",
    "spec/integrations/queues_spec.rb",
    "spec/level.yml",
    "spec/models/ext/hash_ext_spec.rb",
    "spec/models/field_properties_spec.rb",
    "spec/models/net/message_dispatcher_spec.rb",
    "spec/models/net/sub_process_spec.rb",
    "spec/models/player_spec.rb",
    "spec/models/queue/event_queue_spec.rb",
    "spec/models/queue/event_spec.rb",
    "spec/models/queue/sim_loop_spec.rb",
    "spec/models/sim_buildable_spec.rb",
    "spec/models/sim_level_spec.rb",
    "spec/models/sim_matrix_spec.rb",
    "spec/models/sim_object_spec.rb",
    "spec/models/sim_time_unit_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/dummy_level.rb",
    "spec/support/dummy_object.rb",
    "spec/support/dummy_player.rb",
    "spec/support/simulated_object.rb"
  ]
  s.homepage = "http://github.com/grrrisu/Simulator"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "A simulation container based on Celluloid"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<celluloid>, ["~> 0.13"])
      s.add_runtime_dependency(%q<celluloid-io>, ["~> 0.15.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 4.0.2"])
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0.0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<growl>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<celluloid>, ["~> 0.13"])
      s.add_dependency(%q<celluloid-io>, ["~> 0.15.0"])
      s.add_dependency(%q<activesupport>, [">= 4.0.2"])
      s.add_dependency(%q<hashie>, [">= 0"])
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.0.0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<growl>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<celluloid>, ["~> 0.13"])
    s.add_dependency(%q<celluloid-io>, ["~> 0.15.0"])
    s.add_dependency(%q<activesupport>, [">= 4.0.2"])
    s.add_dependency(%q<hashie>, [">= 0"])
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.0.0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<growl>, [">= 0"])
  end
end


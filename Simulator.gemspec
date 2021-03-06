# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: Simulator 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "Simulator"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alessandro Di Maria"]
  s.date = "2016-04-13"
  s.description = "A simulation container based on Celluloid"
  s.email = "adm@m42.ch"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".gitkeep",
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
    "circle.yml",
    "config/level_example.yml",
    "examples/node/.babelrc",
    "examples/node/app.js",
    "examples/node/game_of_life/controller.js",
    "examples/node/game_of_life/game.js",
    "examples/node/game_of_life/index.js",
    "examples/node/game_of_life/receiver.js",
    "examples/node/monitor/game.js",
    "examples/node/monitor/index.js",
    "examples/node/monitor/monitor_chart.js",
    "examples/node/monitor/monitor_controller.js",
    "examples/node/npm-shrinkwrap.json",
    "examples/node/package.json",
    "examples/node/public/crash.html",
    "examples/node/public/game_of_life.html",
    "examples/node/public/index.html",
    "examples/node/public/monitor.html",
    "examples/node/public/reverse.html",
    "examples/node/webpack.config.js",
    "examples/server/boot.rb",
    "examples/server/event/crash_event.rb",
    "examples/server/event/reverse_event.rb",
    "examples/server/event/wait_event.rb",
    "examples/server/game_of_life/event.rb",
    "examples/server/game_of_life/handler.rb",
    "examples/server/game_of_life/world.rb",
    "examples/server/message_handler/handler.rb",
    "lib/boot.rb",
    "lib/exception_handler.rb",
    "lib/ext/hash.rb",
    "lib/sim.rb",
    "lib/sim/buildable.rb",
    "lib/sim/master.rb",
    "lib/sim/matrix/base.rb",
    "lib/sim/matrix/globe.rb",
    "lib/sim/monitor.rb",
    "lib/sim/net/broadcaster.rb",
    "lib/sim/net/message_dispatcher.rb",
    "lib/sim/net/message_handler/admin.rb",
    "lib/sim/net/message_handler/base.rb",
    "lib/sim/net/message_handler/monitor.rb",
    "lib/sim/net/player_connection.rb",
    "lib/sim/net/player_server.rb",
    "lib/sim/net/router.rb",
    "lib/sim/net/session.rb",
    "lib/sim/object.rb",
    "lib/sim/queue/event/action.rb",
    "lib/sim/queue/event/base.rb",
    "lib/sim/queue/event/sim_event.rb",
    "lib/sim/queue/event_queue.rb",
    "lib/sim/queue/fire_worker.rb",
    "lib/sim/queue/sim_loop.rb",
    "lib/sim/queue/sim_master.rb",
    "lib/sim/queue/time_unit.rb",
    "lib/sim/universe.rb",
    "lib/sim/version.rb",
    "log/.gitkeep",
    "node/client/socket_service.js",
    "node/lib/unix_socket.js",
    "node/lib/web_socket.js",
    "node/main.js",
    "node/package.json",
    "node/readme.md",
    "spec/ext/hash_spec.rb",
    "spec/integration/reverse_message_spec.rb",
    "spec/models/buildable_spec.rb",
    "spec/models/matrix/base_spec.rb",
    "spec/models/matrix/globe_spec.rb",
    "spec/models/object_spec.rb",
    "spec/models/queue/sim_loop_spec.rb",
    "spec/models/queue/time_unit_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/dummy_object.rb",
    "spec/support/simulated_object.rb",
    "tasks/doc.rake",
    "tasks/jeweler.rake",
    "tasks/rspec.rake",
    "tmp/sockets/.gitkeep"
  ]
  s.homepage = "http://github.com/grrrisu/Simulator"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "A simulation container based on Celluloid"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<celluloid>, ["~> 0.16.0"])
      s.add_runtime_dependency(%q<celluloid-io>, ["~> 0.16.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<growl>, [">= 0"])
      s.add_development_dependency(%q<byebug>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<celluloid>, ["~> 0.16.0"])
      s.add_dependency(%q<celluloid-io>, ["~> 0.16.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<growl>, [">= 0"])
      s.add_dependency(%q<byebug>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<celluloid>, ["~> 0.16.0"])
    s.add_dependency(%q<celluloid-io>, ["~> 0.16.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<growl>, [">= 0"])
    s.add_dependency(%q<byebug>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end


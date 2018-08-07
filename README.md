### Readme
[![Build Status](https://travis-ci.org/grrrisu/Simulator.svg?branch=master)](https://travis-ci.org/grrrisu/Simulator)
[![Code Climate](https://codeclimate.com/github/grrrisu/Simulator.png)](https://codeclimate.com/github/grrrisu/Simulator)

A simulation container based on [Celluloid](https://github.com/celluloid/celluloid).

### Usage

#### Example

routes:

```ruby
Sim::Net::Router.define do |router|

  router.forward :test, to: Example::SimpleHandler # allow everybody

  router.forward :admin, to: Example::SimpleHandler do |player_id|
    Player.find(player_id).admin? # allow only admins
  end

end
```

handle incoming player events and broadcast them back

```javascript
{scope: 'test', action: 'reverse', args: 'hello world'}
```

```ruby
class Example::SimpleHandler < Sim::Net::MessageHandler::Base

  def reverse text
    queue_player_event do |player_id|
      broadcast player_id, scope: 'test', action: 'reverse', answer: text.reverse
    end
  end

end
```

execute simulation. The class must have a reader to the simulated object and provide a `sim` method

```ruby
class Tick

  attr_reader :object

  def initialize object
    @object = object
  end

  def sim
    # calculate next object state
  end

end
```

#### Examples

see [examples directory](https://github.com/grrrisu/Simulator/tree/master/examples/server)


#### Requirements

* ruby 2.4.x
* node 8.3.x

#### Install

sim server:

```$> bundle```

middleware:

```
$> cd examples/node
$> npm install
$> webpack
```

#### Run Examples

sim server:

```$> ruby examples/server/boot.rb```

middleware:

```$> cd examples/node && node --harmony app.js```


### Development

create a npm link to have all the recent changes in the examples

in folder node issue:
```$>npm link```

then in examples/node create the sym link like so:
```$>npm link simulator-middleware```

#### Testing

for better output comment out ```Celluloid.logger = nil``` in spec_helper.rb

#### Debug PlayerServer

test unix socket with netcat:

```$> nc -U tmp/sockets/pong.sock```

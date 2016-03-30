### Readme
[![Build Status](https://travis-ci.org/grrrisu/Simulator.svg?branch=master)](https://travis-ci.org/grrrisu/Simulator)
[![Code Climate](https://codeclimate.com/github/grrrisu/Simulator.png)](https://codeclimate.com/github/grrrisu/Simulator)

A simulation container based on [Celluloid](https://github.com/celluloid/celluloid).

### Usage

#### Example

routes:

```
Sim::Net::Router.define do |router|

  router.forward :test, to: Example::SimpleHandler # allow everybody

  router.forward :admin, to: Example::SimpleHandler do |player_id|
    player_id.to_i == 123
  end

end
```

####JSON API

```{sope: 'test', action: 'reverse', args: 'hello world'}```

#### Examples

see examples directory


#### Requirements

* ruby 2.3.x
* node 0.12.x

#### Install

sim server:

```$> bundle```

middleware:

```
$> cd examples/node
$> npm install
$> gulp compile
```

#### Run Examples

sim server:

```$> ruby examples/server/boot.rb```

middleware:

```$> node --harmony examples/node/main.js```


### Development

create a npm link to have all the recent changes in the examples

in folder node issue:
```$>npm link```

then in examples/node create the sym link like so:
```$>npm link simulator-middleware```

#### Debug PlayerServer

test unix socket with netcat:

```$> nc -U tmp/sockets/pong.sock```

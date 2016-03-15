### Readme
[![Build Status](https://travis-ci.org/grrrisu/Simulator.svg?branch=master)](https://travis-ci.org/grrrisu/Simulator)
[![Code Climate](https://codeclimate.com/github/grrrisu/Simulator.png)](https://codeclimate.com/github/grrrisu/Simulator)

A simulation container based on [Celluloid](https://github.com/celluloid/celluloid).

####JSON API

```{sope: 'test', action: 'reverse', args: 'hello world'}```


#### Requirements

* ruby 2.3.x
* node 0.12.x

#### Install

sim server:

```$> bundle```

middleware:

```$> cd node && node install```

#### Run

sim server:

```$> ruby lib/boot.rb```

middleware:

```$> node --harmony node/main.js```



### Debug PlayerServer

test unix socket with netcat:

```$> nc -U tmp/sockets/pong.sock```

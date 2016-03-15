### Run

#### Requirements

* ruby 2.3.x
* node 0.12.x

#### Install

```bundle```
```cd node && node install```

#### Middleware

```$> node --harmony node/main.js```

#### Sim Server

```$> ruby lib/boot.rb```


### Debug PlayerServer

test unix socket with netcat:

```$> nc -U pong.sock```

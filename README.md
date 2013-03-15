README
======

A simulation container based on [Celluloid](https://github.com/celluloid/celluloid).

JSON API
--------

Level Actions:
```json
{"action": "start"}
{"action": "create"}
{"action": "load"}
{"action": "stop"}
{"action": "add_player", "params": {"id": "123"}}
{"action": "remove_player", "params": {"id": "123"}}
```
Answers:
```json
{"answer": "return value"}
{"exception": "message"}
```

Player:
```json
{"action": "view", "player": "123"}
{"action": "move", "player": "123", "params": {"x": "-1", "y": "0"}}
```


Copyright
--------

Copyright (c) 2013 Alessandro Di Maria. See LICENSE.txt for further details.

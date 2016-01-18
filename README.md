# lua_redis

lua_redis is a C binding between hiredis and lua, intended to provide a fast and reliable interface with redis from lua.

## Code Example

### Connection

``` lua
redis = require("lua_redis")
instance = redis.connect("test", {["ip"] = "127.0.0.1"})
--'test' is the name of the connection instance, you can pass a table with connection parameters
```
### Commands
``` lua
value = "str value"
instance.set("key", value) 
-- you can call the commands from the instance, you can either pass multiple parameters or a concatenated expression.
instance.get("key")
instance.hset("hash key value")
instance.hgetall("hash")
```
## Motivation

This module should be quite fast(pre-compiled with static hiredis) and it is an excellent experience in binding lua and C for a usefull purpose. Additionally, it provides multiple concurrent connection instances.

## Installation
The build depends on hiredis being installed on the compiling system.

with luarocks:
``` bash
luarocks install lua_redis HIREDIS_DIR=/path/to/hiredis/lib HIREDIS_INCDIR=/path/to/hiredis/include/
```

## Tests:

Test are available through the tests dir using lunit. Please be noted that this depends on having [lunit](http://www.mroth.net/lunit/) installed.

## Contributors:

Feel free to contact at omrieival@gmail.com me regarding any issues, requests or comments about the performance or quality of the package.

## License

Copyright (c) 2016 Omri Eival

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

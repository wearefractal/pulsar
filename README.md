![status](https://secure.travis-ci.org/wearefractal/pulsar.png?branch=master)

## Information

<table>
<tr>
<td>Package</td>
<td>pulsar</td>
</tr>
<tr>
<td>Description</td>
<td>Events + PubSub via WebSockets</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.4</td>
</tr>
</table>

## Example

### Server

```javascript
var Pulsar = require('pulsar');
var server = http.createServer().listen(8080);
var pulse = new Pulsar(server);

channel = pulse.channel('test');
channel.on('ping', function (num) {
  channel.emit('pong', num);
});
```

### Client

```javascript
var pulse = new Pulsar();
channel = pulse.channel('test');
channel.emit('ping', 2);
channel.on('pong', function(num){
  // num === 2
});
```

## Server Usage

### Create

```
-- Options --
path - prefix path (default: "/pulsar")
resource - change to allow multiple servers for one prefix (default: "default")
```

```javascript
var Pulsar = require('pulsar');
var pulse = new Pulsar(8080, {options});
```

## Client Usage

### Create

```
-- Options --
host - server location (default: window.location.hostname)
port - server port (default: window.location.port)
secure - use SSL (default: window.location.protocol)
path - prefix path (default: "/pulsar")
resource - change to allow multiple servers for one endpoint (default: "default")
```

```javascript
var pulse = new Pulsar({options});
```

## LICENSE

(MIT License)

Copyright (c) 2012 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

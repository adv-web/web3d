# Webpack Usage
## Install
open cmd in working dictionary (can use Alt + F12 in Webstorm), run `npm install webpack --save-dev`

## Config
create webpack.config.js in root dictionary, and input:
``` javascript
module.exports = {
    entry: './src/index.js',  
    output: {
        filename: 'bundle.js'  
    }
};
```
`entry` means the entry point for webpack to find the file dependency, `output` means the output file location

## Usage
in HTML file, don't need to include all .js files. just include bundle.js
in js file which is a module, use module.exports to export itself
in js file which wants to use other module, use require 
for example:
``` coffeescript
// in Game.coffee
class Game

  func: =>
    alert 'hello, world'

module.exports = Game

// in index.js
var Game = require('./Game')  // ./ can not be omitted but .js could be omitted
new Game().func()
```

## Pack
when code is modified and you want to run in brower, run `webpack` in cmd to create the bundle.js file

NOTE: if you use some libraries like Three.js, which can use directly (in window object, not have to require it), you can use without require but should include it in your html file.

# Created by duocai on 2017/4/28.

# init express
app = require('express')();
# create a http server
server = require('http').Server(app);
# get socket io
io = require('socket.io')(server)
# server port
port = process.env.PORT || 5000
# whether to print debug message
verbose = true;

#start server (http server)
server.listen(port,()->
  console.log("server started at port: %s", port)
)


# Express server set up

# The express server handles passing our content to the browser,
# As well as routing users where they need to go. This example is bare bones
# and will serve any file the user requests from the root of your web server (where you launch the script from)
# so keep this in mind - this is not a production script but a development teaching tool.

# express router
app.get('/', (req, res) ->
  res.sendFile(__dirname + '/index.html');
)

# This handler will listen for requests on /*, any file from the root of our server.
# See expressjs documentation for more info on routing.
app.get( '/*' , ( req, res, next ) ->
# This is the current file they have requested
  file = req.params[0];

  # For debugging, we can track what files are requested.
  console.log('\t :: Express :: file requested : ' + file) if verbose

  # Send the requesting client the file.
  res.sendfile( __dirname + '/' + file )
)# app.get *

# end of Express Server



# Socket.IO server set up. */

# Express and socket.io can work together to serve the socket.io client files for you.
# This way, when the client requests '/socket.io/' files, socket.io determines what the client needs.

# Enter the game server code. The game server handles
# client connections looking for a game, creating games,
# leaving games, joining games and ending games when they leave.
gameServer = require('./game.server.js')()

# Socket.io will call this function when a client connects,
# So we can send that client looking for a game to play,
# as well as give that client a unique ID to use so we can
# maintain the list if players.
io.on('connection', (client) =>
  # here, 'client' is a socket
  # Generate a new UUID, looks something like
  # 5b2ca132-64bd-4513-99da-90e838ca47d1
  # and store this on their socket/connection
  client.userid = UUID()

  # tell the player they connected, giving them their id
  client.emit('onconnected', { id: client.userid } )

  # now we can find them a game to play with someone.
  # if no game exists with someone waiting, they create one and wait.
  gameServer.findGame(client)

  # Useful to know when someone connects
  console.log('\t socket.io:: player ' + client.userid + ' connected')

  # Now we want to handle some of the messages that clients will send.
  # They send messages here, and we send them to the gameServer to handle.
  client.on('message', (m) => gameServer.onMessage(client, m))
  # 'client.on message' will listen to the message from this l

  # When this client disconnects, we want to tell the game server
  # about that as well, so it can remove them from the game they are
  # in, and make sure the other player knows that they left and so on.
  client.on('disconnect',() =>

    # Useful to know when soomeone disconnects
    console.log('\t socket.io:: client disconnected ' + client.userid + ' ' + client.game_id)

  ) #client.on disconnect
) # sio.sockets.on connection
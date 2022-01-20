module Test.Main where

import Prelude

import Data.Foldable (for_)
import Effect (Effect)
import Effect.Class.Console (log)
import Foreign (unsafeFromForeign)
import Node.HTTP as HTTP
import Node.WebSocket.Server.WebSocketServer as WebSocketServer
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.Socket.Event.EventTypes as WSE
import Web.Socket.Event.MessageEvent as WSME
import Web.Socket.WebSocket as WebSocket

main :: Effect Unit
main = do

  webSocketServer <- WebSocketServer.create (WebSocketServer.defaultOptions { listenOption = WebSocketServer.ListenPort 8000 })
  WebSocketServer.onConnection 
    webSocketServer
    (\webSocket request -> do
      log ("Client connected. HTTP version: " <> HTTP.httpVersion request)
      let target = WebSocket.toEventTarget webSocket
      onMessageListener <- eventListener (\e -> for_ (WSME.fromEvent e >>= WSME.data_ >>> pure) (log <<< unsafeFromForeign))
      addEventListener WSE.onMessage onMessageListener false target
      onCloseListener <- eventListener \_ -> log "Client disconnected"
      addEventListener WSE.onClose onCloseListener false target
    )
  WebSocketServer.onClose 
    webSocketServer
    (log "Server closed")
  WebSocketServer.onListening 
    webSocketServer
    (log "Server listening")
  

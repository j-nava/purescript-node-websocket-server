module Node.WebSocket.Server.WebSocketServer
( ListenOption(..)
, Options
, WebSocketServer
, defaultOptions
, create
, onClose
, onConnection
, onListening
, onHeaders
, onError
)
where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, notNull, null, toNullable)
import Effect (Effect)
import Effect.Exception (Error)
import Node.HTTP (Request, Server) as HTTP
import Node.HTTP.Client (RequestHeaders) as HTTP
import Web.Socket.WebSocket (WebSocket)

foreign import data WebSocketServer :: Type
foreign import _create :: 
  Nullable Int ->         -- backlog
  Boolean ->              -- clientTracking
  Nullable String ->      -- host
  Int ->                  -- maxPayload
  Nullable String ->      -- path
  Boolean ->              -- skipUTF8Validation
  Nullable HTTP.Server -> -- server
  Nullable Int ->         -- port
  Nullable Boolean ->     -- noServer
  Effect WebSocketServer


create :: Options -> Effect WebSocketServer
create options = 
  _create 
    (toNullable options.backlog)
    options.clientTracking
    (toNullable options.host)
    options.maxPayload
    (toNullable options.path)
    options.skipUTF8Validation
    jsListenOption.server
    jsListenOption.port
    jsListenOption.noServer

  where
    jsListenOption = toJSListenOption options.listenOption

type JSListenOption =
  { noServer :: Nullable Boolean
  , server :: Nullable HTTP.Server
  , port :: Nullable Int
  }

toJSListenOption :: ListenOption -> JSListenOption
toJSListenOption = case _ of
  ListenServer server -> { noServer: null, server: notNull server, port: null }
  ListenPort port -> { noServer: null, server: null, port: notNull port }
  ListenNoServer -> { noServer: notNull true, server: null, port: null }

data ListenOption
  = ListenServer HTTP.Server
  | ListenPort Int
  | ListenNoServer

type Options =
  { backlog :: Maybe Int
  , clientTracking :: Boolean
  , host :: Maybe String
  , maxPayload :: Int
  , listenOption :: ListenOption
  , path :: Maybe String
  , skipUTF8Validation :: Boolean
  }

defaultOptions :: Options
defaultOptions = 
  { backlog: Nothing
  , clientTracking: true
  , host: Nothing
  , maxPayload: 100 * 1024 * 1024
  , listenOption: ListenPort 8080
  , path: Nothing
  , skipUTF8Validation: false
  }

foreign import onClose :: WebSocketServer -> Effect Unit -> Effect Unit
foreign import onListening :: WebSocketServer -> Effect Unit -> Effect Unit
foreign import onConnection :: WebSocketServer -> (WebSocket -> HTTP.Request -> Effect Unit) -> Effect Unit
foreign import onError :: WebSocketServer -> (Error -> Effect Unit) -> Effect Unit
foreign import onHeaders :: WebSocketServer -> (HTTP.RequestHeaders -> HTTP.Request -> Effect Unit) -> Effect Unit

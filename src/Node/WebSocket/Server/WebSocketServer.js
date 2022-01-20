"use strict";

var WebSocketServer = require("ws").WebSocketServer;

exports._create = function(backlog) {
  return function(clientTracking) {
    return function(host) {
      return function(maxPayload) {
        return function(path) {
          return function(skipUTF8Validation) {
            return function (server) {
              return function (port) {
                return function (noServer) {
                  return function() {
                    return new WebSocketServer(
                      { backlog
                      , clientTracking
                      , host
                      , maxPayload
                      , path
                      , skipUTF8Validation
                      , server
                      , port
                      , noServer
                      }
                    );
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

exports.onClose = function (socketServer) {
  return function (callback) {
    return function () {
      socketServer.on("close", callback);
    }
  }
}

exports.onListening = function (socketServer) {
  return function (callback) {
    return function () {
      socketServer.on("listening", callback);
    }
  }
}

exports.onConnection = function (socketServer) {
  return function (callback) {
    return function () {
      socketServer.on("connection", function(socket, request) {
        callback(socket)(request)();
      });
    }
  }
}

exports.onError = function (socketServer) {
  return function (callback) {
    return function () {
      socketServer.on("error", function(error) {
        callback(error)();
      });
    }
  }
}

exports.onHeaders = function (socketServer) {
  return function (callback) {
    return function () {
      socketServer.on("headers", function(headers, request) {
        callback(headers)(request)();
      });
    }
  }
}

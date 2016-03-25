'use strict'

ipcMain = require('electron').ipcMain
screenshot = require('electron-screenshot-service')

ipcMain.on 'capture-request', (event, arg = {}) ->
  promises = []

  options = {
    url: arg.url or ''
    width: arg.width or 1024
    height: arg.height or 1024
    count: arg.count or 3
  }

  for i in [0...options.count]
    do (i) ->
      console.log {
        url: options.url
        width: options.width

        delay: i
      }
      promises.push screenshot(
        url: options.url
        width: options.width
        height: options.height
        delay: i
      )
      return
  
  # console.log options

  Promise.all promises
  .then (imgs) ->
    console.log '>>>>'
    event.sender.send 'capture-response', imgs
    return
  , (err) ->
    console.log err
    return
  console.log '>>>'
  return
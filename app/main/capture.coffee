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

  event.sender.send 'capture-response-p', 'capture step 1'

  event.sender.send 'capture-response-p', options

  for i in [0...options.count]
    do (i) ->
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
    event.sender.send 'capture-response-p', 'capture err'
    event.sender.send 'capture-response-p', err
    console.log err
    return

  event.sender.send 'capture-response-p', 'capture step 2'
  

  console.log '>>>'
  return
'use strict'

angular.module 'electron-app'
.service 'util', ->

  uint8ToString = (u8a) ->
    CHUNK_SZ = 0x8000
    c = []
    i = 0
    while i < u8a.length
      c.push String.fromCharCode.apply(null, u8a.subarray(i, i + CHUNK_SZ))
      i += CHUNK_SZ
    c.join ''

  uint8ToString: uint8ToString
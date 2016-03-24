'use strict'

ipcRenderer = require('electron').ipcRenderer

angular.module 'electron-app' 
.controller 'HomeController', ($scope) ->
  vm = @

  vm.input =
    url: 'http://m.naver.com'


  ipcRenderer.on 'capture-response', (arg, response) ->
    console.log(response);
    return

    # var img;
    # img = document.createElement('img');
    # img.src = response.dataURL;
    # document.getElementById('capture-img').src = response.dataURL;
  #   $timeout(function() {
  #     vm.showCaptured = true;
  #   });
  # });


  vm.capture = ->
    console.log 'send done'
    ipcRenderer.send 'capture-request', vm.input
    console.log 'send done 1'
    return

  vm.save = ->
    return

  $scope.$watch 'vm.input.url', (url) ->
    if url and url.search(/^[a-zA-Z]+:\/\//) is -1
      vm.input.url = "http://#{url}"
    return

  return

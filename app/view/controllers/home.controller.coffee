'use strict'

ipcRenderer = require('electron').ipcRenderer

angular.module 'electron-app' 
.controller 'HomeController', ($scope, $element, $timeout, util) ->
  vm = @

  thumbHeight = 100

  vm.input =
    url: 'http://m.naver.com'
    width: 375
    height: 500

  vm.select = (screenshot) ->
    vm.selected = screenshot
    return

  thumbList = $element.find('.thumb-list')

  vm.thumbs = []

  ipcRenderer.on 'capture-response', (arg, images) ->
    # console.log(response);
    vm.thumbs = []
    $timeout ->
      for image in images

        blob = new Blob [image.data], { type: 'image/png' }
        # url = URL.createObjectURL(blob)
        thumbHeight
        vm.thumbs.push
          url: URL.createObjectURL(blob)
          size: image.size
          thumbSize:
            width: image.size.width * (thumbHeight / image.size.height)
            height: thumbHeight


      return


      # image.data
      # image.dataURL = util.uint8ToString image.data
      # console.log image


      # img = document.createElement 'img'


      # img.width = 500
      # console.log btoa(image.dataURL)
      # img.src = url
      # # img.src = 'data:image/png;base64,' + btoa(image.dataURL)
      # thumbList.append img
      # console.log '>>> image append done'
      # pageImg.src="data:image/png;base64,"
    
    # $element.find('')[0].src = 'aa.png'
    # $element.find('img')[0].src = 'data:image/png;base64,' + btoa(image.dataURL)
    # var imgByteStr = String.fromCharCode.apply(null, this.imgBytes);

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

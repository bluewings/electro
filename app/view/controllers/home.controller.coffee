'use strict'

ipcRenderer = require('electron').ipcRenderer

angular.module 'electron-app' 
.controller 'HomeController', ($scope, $element, $window, $document, $timeout, devices) ->
  vm = @

  win = $($window)

  thumbHeight = 80

  # canvas = $element.find('canvas')[0]
  # ctx = canvas.getContext '2d'

  vm.devices = devices

  vm.status = {}

  vm.canvasOptions = {
    test: 1234
  }

  resizeHandler = ->
    # before = JSON.stringify(vm.status)
    # vm.status.cHeight = $document[0].documentElement.clientHeight
    vm.status = 
      clientHeight: $document[0].documentElement.clientHeight
      navbarTopHeight: $element.find('.navbar-fixed-top').outerHeight()
      navbarBottomHeight: $element.find('.navbar-fixed-bottom').outerHeight()

    vm.status.marginTop = vm.status.navbarTopHeight
    vm.status.contentHeight = vm.status.clientHeight - vm.status.navbarTopHeight - vm.status.navbarBottomHeight
    # $element.find('.navbar-fixed-bottom')
    # afterbefore = JSON.stringify(vm.status)
    return

  resizeHandler()

  unbinds = []
  unbinds.push win.$on 'resize', ->
    $timeout resizeHandler
    return

  $scope.$on '$destroy', ->
    for unbind in unbinds
      unbind()
    return


  vm.rates = [25, 50, 75, 100, 125, 150]

  $scope.$watch 'vm.selected', (selected) ->
    if selected

      console.log selected.size
      console.log vm.status


      renderCanvas()
    return

  $scope.$watch 'vm.rate', (rate) ->
    renderCanvas()
    return

  timer = null
  renderCanvas = ->
    if vm.selected and vm.rate

      vm.canvasOptions.rate = vm.rate
      vm.canvasOptions.source = vm.selected

      console.log '>>>>>>>>>>'


      return




      clearTimeout timer
      timer = setTimeout ->
        canvas.width = Math.floor(vm.selected.size.width * vm.rate / 100)
        canvas.height = Math.floor(vm.selected.size.height * vm.rate / 100)

        img = document.createElement 'img'
        img.onload = ->
          ctx.drawImage img,
            0, 0, vm.selected.size.width, vm.selected.size.height
            0, 0, canvas.width, canvas.height
          return

        img.src = vm.selected.url


        return
    return



  vm.input =
    url: 'http://m.naver.com'
    width: 375
    height: 500

  vm.setDeviceSize = (device) ->
    vm.input.width = device.screen[0]
    vm.input.height = device.screen[1]
    return

  vm.setRate = (rate) ->
    vm.rate = rate
    return

  vm.rotate = ->
    width = vm.input.width
    vm.input.width = vm.input.height
    vm.input.height = width
    return

  vm.select = (screenshot) ->
    vm.selected = screenshot
    return

  thumbList = $element.find('.thumb-list')

  vm.screenshots = []


  blob = null

  ipcRenderer.on 'capture-response-p', (arg, images) ->
    # console.log(response);
    console.log '%ccapture results', 'background-color:yellow'
    console.log arguments
    return

  ipcRenderer.on 'capture-response', (arg, images) ->
    # console.log(response);
    vm.screenshots = []
    $timeout ->
      for image in images

        blob = new Blob [image.data], { type: 'image/png' }
        # url = URL.createObjectURL(blob)
        thumbHeight
        vm.screenshots.push
          url: URL.createObjectURL(blob)
          size: image.size
          thumb:
            width: image.size.width * (thumbHeight / image.size.height)
            height: thumbHeight

      screenshot = vm.screenshots[0]
      if vm.status.contentHeight < screenshot.size.height
        vm.rate = Math.floor(vm.status.contentHeight / screenshot.size.height * 100)
      else
        vm.rate = 100
      vm.select screenshot
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
    vm.selected = null
    vm.screenshots = []
    ipcRenderer.send 'capture-request', vm.input
    console.log 'send done 1'
    return

  setTimeout ->
    vm.capture()
    return
  , 500

  vm.save = ->
    formData = new FormData()
    formData.append 'data', blob
    $.ajax
      type: 'POST'
      url: 'http://demo.searchad.naver.com'
      data: formData
      processData: false
      contentType: false
    .done (data) ->
      console.log data
      return
    return

  $scope.$watch 'vm.input.url', (url) ->
    if url and url.search(/^[a-zA-Z]+:\/\//) is -1
      vm.input.url = "http://#{url}"
    return

  return

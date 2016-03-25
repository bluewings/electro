'use strict'

angular.module 'electron-app'
.directive 'cropCanvas', ->
  restrict: 'E'
  replace: true
  templateUrl: 'view/directives/crop-canvas.directive.html'
  scope:
    _canvasOptions: '=canvasOptions'
    # _alertClass: '@alertClass'
  bindToController: true
  controllerAs: 'vm'
  # controller: ($scope, $rootScope, $element, $translate, global, util) ->
  controller: ($scope, $element) ->

    vm = @

    # return
    vm.metric = {
      padding: 25
      width: 0
      height: 0
    }

    vm.metric = vm.metric

    canvas = $element.find('canvas')[0]
    ctx = canvas.getContext '2d'

    vm.resizeAlso = true

    vm.cropInfo = {
      top: 0
      left: 0
      right: 0
      bottom: 0
    }

    img = null


    updateCropInfo = (type) ->

      # console.log ui
      vm.cropInfo.top = resizer.top.height() - vm.metric.padding
      vm.cropInfo.left = resizer.left.width() - vm.metric.padding
      vm.cropInfo.right = resizer.right.width() - vm.metric.padding
      vm.cropInfo.bottom = resizer.bottom.height() - vm.metric.padding

      if img
        ctx.clearRect 0, 0, canvas.width, canvas.height

        ctx.translate vm.metric.padding, vm.metric.padding
        ctx.drawImage img,
          0, 0, source.size.width, source.size.height
          0, 0, vm.metric.iWidth, vm.metric.iHeight
        ctx.translate -vm.metric.padding, -vm.metric.padding

        top = vm.cropInfo.top + vm.metric.padding
        left = vm.cropInfo.left + vm.metric.padding
        right = vm.cropInfo.right + vm.metric.padding
        bottom = vm.cropInfo.bottom + vm.metric.padding

        ctx.fillStyle = 'rgba(196,196,196,.5)'

        ctx.fillRect 0, 0, canvas.width, top
        ctx.fillRect 0, top, left, canvas.height - top - bottom
        ctx.fillRect 0, canvas.height - bottom, canvas.width, bottom
        ctx.fillRect canvas.width - right, top, right, canvas.height - top - bottom

        ctx.strokeStyle = '#bbb'
        ctx.strokeRect left - .5, top - .5, canvas.width - right - left, canvas.height - top - bottom


      return


    resizer =
      top: $element.find('.resizer-top')
      left: $element.find('.resizer-left')
      right: $element.find('.resizer-right')
      bottom: $element.find('.resizer-bottom')

    resizer.top.resizable({
      handles: 's' # south
      minHeight: vm.metric.padding
      resize: (event, ui) ->

        updateCropInfo 'top'
        return
    })

    resizer.left.resizable({
      handles: 'e' # east
      minWidth: vm.metric.padding
      start: (event, ui) ->
        resizer.right.original =
          left: parseInt(resizer.right.css('left'), 10)
          width: resizer.right.width()
      resize: (event, ui) ->
        
        # console.log ui
        dist = ui.size.width - ui.originalSize.width
        # console.log dist
        # console.log resizer.right.original
        console.log resizer.right.original.left - dist
        resizer.right.css 
          left: resizer.right.original.left - dist
          width: resizer.right.original.width + dist
        # if vm.resizeAlso
        updateCropInfo 'left'
        return
    })

    resizer.right.resizable({
      handles: 'w' # west
      minWidth: vm.metric.padding
      start: (event, ui) ->
        resizer.left.original =
          # left: parseInt(resizer.left.css('left'), 10)
          width: resizer.left.width()
      resize: (event, ui) ->
        # return false

        dist = ui.size.width - ui.originalSize.width
        # console.log dist
        # console.log resizer.right.original
        # console.log resizer.right.original.left - dist
        resizer.left.css 
          # left: resizer.right.original.left - dist
          width: resizer.left.original.width + dist
        updateCropInfo 'right'
    })

    resizer.bottom.resizable({
      handles: 'n' # north
      minHeight: vm.metric.padding
      resize: (event, ui) ->
        updateCropInfo 'bottom'
        return
    })



    source = null
    render = ->
      source = vm._canvasOptions.source
      rate = (vm._canvasOptions.rate or 100) / 100

      vm.source = source

      if source and rate

        canvas.width = Math.floor(source.size.width * rate) + vm.metric.padding * 2
        canvas.height = Math.floor(source.size.height * rate) + vm.metric.padding * 2

        

        vm.metric.width = canvas.width
        vm.metric.height = canvas.height
        vm.metric.iWidth = canvas.width - vm.metric.padding * 2
        vm.metric.iHeight = canvas.height - vm.metric.padding * 2

        console.log source.size.width * rate 



        img = document.createElement 'img'
        img.onload = ->
          ctx.translate vm.metric.padding, vm.metric.padding
          ctx.drawImage img,
            0, 0, source.size.width, source.size.height
            0, 0, vm.metric.iWidth, vm.metric.iHeight
          ctx.translate -vm.metric.padding, -vm.metric.padding
          updateCropInfo()
          return

        img.src = source.url

      return

    $scope.$watchGroup ['vm._canvasOptions.source', 'vm._canvasOptions.rate'], (values) ->
      render()

      return

    return

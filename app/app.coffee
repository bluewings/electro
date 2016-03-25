'use strict'

angular.module 'electron-app', ['ui.router', 'ui.bootstrap', 'angularResizable']
.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider.state 'wrap',
    url: '/'
    templateUrl: 'view/controllers/home.controller.html'
    controller: 'HomeController'
    controllerAs: 'vm'
  return

.run ->

  # jQuery 로 바인딩한 함수를 쉽게 제거할 수 있도록 하는 함수.
  # 사용법은 angular 의 $on 과 같다. 리턴값으로 unbind 함수를 반환
  unless $.fn.$on
    $.fn.$on = (events, handler, execute, trigger) ->
      that = @
      uniq = parseInt(Math.random() * 100000, 10)
      events = events.replace /([^\s])(\s|$)/g, "$1.#{uniq}$2"
      @each ->
        if trigger
          $(this).on events, -> $timeout handler
        else
          $(this).on events, handler
      if execute
        handler {}
      unbind = ->
        that.each ->
          $(this).off events

  return
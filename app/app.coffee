
angular.module('electron-app', ['ui.router'])
.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider.state 'wrap',
    url: '/'
    templateUrl: 'view/controllers/home.controller.html'
    controller: 'HomeController'
    controllerAs: 'vm'
  return
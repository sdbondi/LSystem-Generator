angular.module('lsystemGeneratorApp', ['lsystem.controllers', 'fixate.ui'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

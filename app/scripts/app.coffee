angular.module('lsystemGeneratorApp', ['lsystem.controllers'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

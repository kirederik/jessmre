'use strict';

angular.module('myApp', [
  'ngRoute',
  'myApp.filters',
  'myApp.services',
  'myApp.directives',
  'myApp.controllers'
]).
  config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/problem', {
      templateUrl: 'partials/problem.html', 
      controller: 'ProblemCtrl'
    })
    .otherwise({redirectTo: '/problem'});
  }]);

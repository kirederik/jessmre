'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  controller('ProblemCtrl', ['$scope', 
    function($scope) {
    $scope.welcome = "Welcome to the Problem";
  }]);
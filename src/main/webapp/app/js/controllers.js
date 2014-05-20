'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  controller('ProblemCtrl', ['$scope', 'Step', 
  function($scope, Step ) {
    $scope.welcome = "Welcome to the Problem";
    var Step = new Step({index: 0});
    $scope.problem = Step.generateLesson();
  }]);
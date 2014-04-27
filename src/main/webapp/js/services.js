'use strict';

/* Services */

angular.module('myApp.services', []).
  factory('Step', [function() {
    return function Step(options) {
      var config = options || {}, 
        lnumber = (config.hasOwnProperty("index")) ? config.index : 0;

      Step.prototype.generateLesson = function() {
        return {
          top: 123,
          bot:  13
        };
      };

    };
  }]);

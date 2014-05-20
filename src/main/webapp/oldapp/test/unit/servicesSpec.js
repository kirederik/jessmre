'use strict';

/* jasmine specs for services go here */

describe('Services', function() {
  beforeEach(module('myApp.services'));
  describe('Step', function() {
    describe("Lessons", function() {
      it('Lesson 1', inject(function(Step) {
        expect(Step.lesson1(9,2)).toEqual(true);
      }));
    })
  });
});

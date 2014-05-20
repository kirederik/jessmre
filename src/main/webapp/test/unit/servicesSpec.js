'use strict';

/* jasmine specs for services go here */

describe('Services', function() {
  beforeEach(module('myApp.services'));
  describe('Step', function() {
    describe("Lessons", function() {
      var step;
      beforeEach(inject(function(Step) {
        step = new Step();
      }));
      it('Lesson 1', function() {
        expect(step.lesson1(9,2)).toEqual(true);
        expect(step.lesson1(1,2)).toEqual(false);
        expect(step.lesson1(22,1)).toEqual(false);
        expect(step.lesson1(9,12)).toEqual(false);
        expect(step.lesson1(0,0)).toEqual(false);
        expect(step.lesson1(0,1)).toEqual(false);
      });

      it('Lesson 2', function() {
        expect(step.lesson2(99, 11)).toEqual(true);
        expect(step.lesson2(12, 12)).toEqual(true);
        expect(step.lesson2(12, 14)).toEqual(false);
        expect(step.lesson2(12, "04")).toEqual(false);
        expect(step.lesson2(78, 69)).toEqual(false);
        expect(step.lesson2(11, 2)).toEqual(false);
        expect(step.lesson2(70, 24)).toEqual(false);
        expect(step.lesson2(70, 70)).toEqual(true);
      });

      it('Lesson 3', function() {
        expect(step.lesson3(78, 69)).toEqual(true);
        expect(step.lesson3(81, 12)).toEqual(true);
        expect(step.lesson3(45, 37)).toEqual(true);
        expect(step.lesson3(40, 30)).toEqual(true);
        expect(step.lesson3(55, 99)).toEqual(false);
        expect(step.lesson3(40, 19)).toEqual(false);
        expect(step.lesson3(55, 1)).toEqual(false);
        expect(step.lesson3(100,25)).toEqual(false);
      });

      it('Lesson 4', function() {
        expect(step.lesson4(78, 9)).toEqual(true);
        expect(step.lesson4(42, 8)).toEqual(true);
        expect(step.lesson4(64, 7)).toEqual(true);
        expect(step.lesson4(70, 9)).toEqual(false);
        expect(step.lesson4(55, 99)).toEqual(false);
        expect(step.lesson4(40, 19)).toEqual(false);
        expect(step.lesson4(55, 17)).toEqual(false);
        expect(step.lesson4(100,25)).toEqual(false);
      });

      it('Lesson 5', function() {
        expect(step.lesson5(70, 9)).toEqual(true);
        expect(step.lesson5(40, 12)).toEqual(true);
        expect(step.lesson5(90, 78)).toEqual(true);
        expect(step.lesson5(70, 71)).toEqual(false);
        expect(step.lesson5(100, 12)).toEqual(false);
        expect(step.lesson5(41, 34)).toEqual(false);
        expect(step.lesson5(20, 10)).toEqual(false);
        expect(step.lesson5(51,25)).toEqual(false);
      });

      it('Lesson 6', function() {
        expect(step.lesson6(100, 9)).toEqual(true);
        expect(step.lesson6(200, 12)).toEqual(true);
        expect(step.lesson6(900, 101)).toEqual(true);
        expect(step.lesson6(111, 9)).toEqual(false);
        expect(step.lesson6(111, 99)).toEqual(false);
        expect(step.lesson6(11, 9)).toEqual(false);
        expect(step.lesson6(5000, 323)).toEqual(false);
        expect(step.lesson6(400, 20)).toEqual(false);
        expect(step.lesson6(498, 122)).toEqual(false);
      });

      it('Lesson 7', function() {
        expect(step.lesson7(255,166)).toEqual(true);
        expect(step.lesson7(332, 244)).toEqual(true);
        expect(step.lesson7(321, 204)).toEqual(false);
        expect(step.lesson7(400, 9)).toEqual(false);
        expect(step.lesson7(123, 100)).toEqual(false);
        expect(step.lesson7(555, 55)).toEqual(false);
      });
    });
  });
});

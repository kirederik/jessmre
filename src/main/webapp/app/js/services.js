'use strict';

/* Services */

angular.module('myApp.services', []).
  constant('TEXT', 0).
  constant('IMAGE', 1).
  constant('NUMBERS', 2).
  constant('EXPL_TEXT', 3).
  constant('EXPL_PROC', 4).
  constant('OPERANDS', 5).
  constant('CONCEPTS', 6).
  factory('MRE', ['TEXT','IMAGE', 'NUMBERS', 'EXPL_TEXT', 'EXPL_PROC', 
    'OPERANDS', 'CONCEPTS', function(TEXT, IMAGE, NUMBERS, EXPL_TEXT, 
      EXPL_PROC, OPERANDS, CONCEPTS) {
    return {
      txt: {
        value: TEXT,
        genRep: 'textRepres'
      },
      img: {
        value: IMAGE,
        genRep: 'imageRepres'
      },
      num: {
        value: NUMBERS,
        genRep: 'numbersRepres'
      },
      exp_txt: {
        value: EXPL_TEXT,
        genRep: 'explTextRep'
      },
      exp_prc: {
        value: EXPL_PROC,
        genRep: 'explProcRep'
      },
      opr: {
        value: OPERANDS,
        genRep: 'operandsRepres'
      },
      con: {
        value: CONCEPTS,
        genRep: 'conceptsRepres'
      }
    };
  }]).
  factory('Representation', ['MRE', function(mre) {
    return function Representation(options) {
      // Texto é o padrão.
      var type = options.type || 0;
      var fn;
      var top = options.numbers.top;
      var bot = options.numbers.bot;
      var genRep = {
        textRepres: function() {
          var text = "João "
        }
      }


      for (rep in mre) {
        if (rep.value == type) {
          fn = 
          break;
        }
      }


    };
  }]).
  factory('Step', [function() {
    return function Step(options) {
      var config = options || {}, 
        lnumber = (config.hasOwnProperty("index")) ? config.index : 0;

      var randomInt = function(max) {
        return Math.random() * max;
      };

      Step.prototype.lesson1 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        if (ts.length != bs.length) return false;
        for (var i = 0, len = ts.length; i < len; i++) {
          if (ts[i] == "0" || Number(ts[i]) < Number(bs[i]))
            return false;
        }
        return true;
      }

      Step.prototype.lesson2 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        if (ts.length == 1) return false;
        for (var i = 0, len = bs.length; i < len; i++) {
          if ( (ts[i] == "0" && bs[i] != 0) || Number(ts[i]) < Number(bs[i]))
            return false;
        }
        return true;
      }

      Step.prototype.lesson3 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        if (ts.length != 2 || bs.length != 2) return false;
        for (var i = 0, len = bs.length; i < len; i++) {
          if ( (ts[i] == "0" && bs[i] != 0))
            return false;
        }
        return true;
      }

      Step.prototype.lesson4 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        if (ts.length != 2 || bs.length != 1) return false;
        for (var i = 0, len = bs.length; i < len; i++) {
          if (Number(bs[i]) < Number(ts[i]) || ts[i] == "0")
            return false;
        }
        return true;
      }
      Step.prototype.lesson5 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        if (ts.length != 2) return false;
        return (ts[0] == 0 && bs[0] != 0);
      }
      Step.prototype.lesson6 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        if (ts.length != 3) return false;
        return (ts[0] == 0 && ts[1] == 0 && bs[0] != 0);
      }

      Step.prototype.lesson7 = function(top, bot) {
        if (top < bot ) return false;
        var ts = top.toString().split("").reverse(),
            bs = bot.toString().split("").reverse();
        var bnumber = 0;
        for (var i = 0, len = bs.length; i < len; i++) {
          if (Number(bs[i]) > Number(ts[i]))
            bnumber++;
        }
        return bnumber >= 2;
      }


      Step.prototype.generateLesson = function() {
        var problem = {};
        var top, bot;
        switch (lnumber) {
          case 0:
            // Subtração 1 digito top e bot
            top = randomInt(10);
            bot = randomInt(10);
            if (top < bot) {
              var tmp = top;
              top = bot;
              bot = tmp;
            }
            break;
          case 1:
            // 2 dígitos, top e bot
            do {
              top = randomInt(100);
              bot = randomInt(100);
            } while (!this.lesson1(top, bot))
            break;
          case 2:
            // 2 top, 1 boot
            do {
              top = randomInt(100);
              bot = randomInt(10);
            } while (!this.lesson2(top, bot))
            break;
          case 3:
            // 2 top, 2 bot - emprestimo
            do {
              top = randomInt(100);
              bot = randomInt(100);
            } while (!this.lesson3(top, bot))
            break;
          case 4:
            // 2 top, 1 bot, emprestimo
            do {
              top = randomInt(100);
              bot = randomInt(10);
            } while (!this.lesson4(top, bot))
            break;
          case 5:
            // top > 1, emprestimo de 0
            do {
              top = randomInt(100);
              bot = randomInt(100);
            } while (!this.lesson5(top, bot))
            break;
          case 6:
            // top > 3, emprestimo através de 0
            do {
              top = randomInt(10);
              top = Number(top + "00");
              bot = randomInt(10);
            } while (!this.lesson6(top, bot))
            break;
          case 7:
            // top > 3, emprestimo 2x
            do {
              top = randomInt(1000);
              bot = randomInt(100);
            } while (!this.lesson7(top, bot))
            break;
          default:
            return this.randomLesson();
        }
        return {
          top: Number(top.toFixed()),
          bot: Number(bot.toFixed())
        };
      };

      Step.prototype.nextLesson = function() {
        lnumber++;
      }

    };
  }]);

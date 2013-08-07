(function(angular) {
	'use strict';

	var module = angular.module('lsystem.controllers', []);

	module.controller('MainCtrl', function ($scope) {
		angular.extend($scope, {
		    startString: 'A',
        startX: 0,
        startY: 0,
		    aRule: 'B-A-B',
		    bRule: 'A+B+A',
		    angle: 60,
        scale: 5,
		    aDirection: 'F',
		    bDirection: 'F',
		    n: 10
		  });

		  $scope.rules = function() {
        return {A: $scope.aRule, B: $scope.bRule};
      };

      $scope.getString = function() {
        var rules = $scope.rules();

        var _pass = function(s, n) {
          if (n === 0) {
            return s;
          }

          var i = 0,
              str = '';

          for (;i < s.length; i++) {
            var rule = rules[s[i]];
            if (!rule) {
              str += s[i];
              continue;
            }

            str += rule;
          };

          return _pass(str, n - 1);
        };

        return _pass($scope.startString, +$scope.n);
      };

      var canvas = document.getElementById('draw'),
          ctx = canvas.getContext('2d');

      var render = function(string) {
        ctx.strokeStyle = "#000";

         var i, x = +$scope.startX,
              y = +$scope.startY,
              dir = 0,
              scale = +$scope.scale,
              rads = +$scope.angle * Math.PI / 180;

          ctx.beginPath();
          ctx.moveTo(x, y);
        for (i = 0; i < string.length; i++) {
          var chr = string[i];
          if (chr == 'A' || chr == 'B') {
            x += Math.cos(dir) * scale;
            y += Math.sin(dir) * scale;

            ctx.lineTo(x, y)
          } else if (chr == '+' || chr == '-') {
            dir += +(chr + '1') * rads;
          }
        }

        ctx.stroke();
      };

      $scope.generate = function() {
        $scope.busy = true;
        var n = +$scope.n;
        if (!n || +n > 15) { return; }
        ctx.fillStyle = '#FFF';
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        render($scope.getString());
        $scope.busy = false;
      };
	});

}(this.angular));

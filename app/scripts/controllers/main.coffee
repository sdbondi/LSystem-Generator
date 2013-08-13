module = angular.module 'lsystem.controllers', []

module.controller 'MainCtrl', ['$scope', '$timeout', ($scope, $timeout) ->
	angular.extend $scope,
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

	getRules = ->
		return {
			A:
				string: $scope.aRule,
				direction: $scope.aDirection
			B:
				string: $scope.bRule,
				direction: $scope.bDirection
		}

	genString = ->
		rules = getRules();

		_pass = (s, n) ->
			if n is 0
				return s

			str = ''
			for i in [0..s.length]
				rule = rules[s[i]]
				if not rule
					str += s[i]
					continue

				str += rule.string

			return _pass(str, n - 1)

		return _pass($scope.startString, +$scope.n)

	canvas = document.getElementById('draw')
	ctx = canvas.getContext('2d')

	render = (string) ->
		ctx.strokeStyle = '#000'

		rules = getRules()
		x = +$scope.startX
		y = +$scope.startY
		dir = 0
		scale = +$scope.scale
		angle = +$scope.angle * Math.PI / 180

		ctx.beginPath()
		ctx.moveTo(x, y)

		for i in [0..string.length]
			chr = string[i]

			if chr in ['A', 'B']
				rule = rules[chr]
				moveDir = if rule.direction is 'F' then 1 else -1
				x += moveDir * Math.cos(dir) * scale
				y += moveDir * Math.sin(dir) * scale

				ctx.lineTo(x, y)
			else if chr in ['+', '-']
				dir += +(chr + '1') * angle

		ctx.stroke()

	$scope.generate = ->
		$scope.busy = true
		$timeout ->
			n = +$scope.n
			if !n || +n > 15
				return

			ctx.clearRect(0, 0, canvas.width, canvas.height)
			render(genString())
			$scope.busy = false

	$scope.$watch 'aDirection + bDirection', $scope.generate
]

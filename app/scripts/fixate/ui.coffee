
module = angular.module 'fixate.ui', []

module.directive 'f8SliderBar', ->
	calcPercentage = (value, min, max) ->
		(value - min) / (max - min) * 100

	calculateValue = (perc, min, max) ->
		(perc / 100) * (max - min) + min

	restrict: 'EA',
	scope: {
		min: '@',
		max: '@',
		model: '=',
		onMouseUp: '&',
		onMouseDown: '&',
		onChange: '&change'
	},
	template: '<a href="javascript:void(0);" class="slider-container">
			<i class="slider-progress" ng-style="{width: percentage+\'%\'}"></i>
			<i class="slider-handle" ng-style="{left: percentage+\'%\'}"></i>
		</a>',

	link: (scope, element, attrs) ->
		$bar          = element.children().eq(0)
		barOffset     = null
		barWidth      = null
		$body         = angular.element(document.body)
		$window       = angular.element(window)
		resizeTimeout = null

		scope.$watch 'model', (model) ->
			perc = scope.percentage = checkPercentage(
				calcPercentage(scope.model, scope.min, scope.max)
			)

		# Functions 
		setModel = (value) ->
			scope.model = value if scope.model?
			scope.$apply()

		bindMouse = ->
			$body.on
				mousemove: mouseMove
				mouseup: mouseUp
				mousedown: mouseDown
				mouseenter : mouseEnter

		unbindMouse = ->
			$body.off
				mousemove: mouseMove
				mouseup: mouseUp
				mousedown: mouseDown
				mouseenter: mouseEnter

		checkPercentage = (perc) ->
			if perc > 100
				perc = 100
			else if perc < 0
				perc = 0
			perc

		# Events
		resize = (e) ->
			barOffset = $bar.offset()
			barWidth = $bar.width()

		mouseEnter = (e) ->
			if e.button is 0
				# Update model and unbind 
				# Handles case when entering from off the screen
				mouseUp.apply(this, e)

		mouseMove = (e) ->
			perc = calcPercentage(e.clientX, barOffset.left, barOffset.left + barWidth)

			scope.percentage = perc = checkPercentage(perc)
			setModel(Math.round(calculateValue(perc, +scope.min, +scope.max)))

			scope.onChange({ percentage: perc }) if angular.isFunction(scope.onChange)

		mouseUp = (e) ->
			unbindMouse()
			scope.onMouseUp()
		
		mouseDown = (e) ->
			scope.onMouseDown()

		$bar.on
			mousedown: (e) ->
				e.preventDefault()
				# Update when clicking on bar
				barWidth = $(this).width()
				mouseMove.call(this, e)
				bindMouse()

		throttledResize = () ->
			if resizeTimeout?
				clearTimeout(resizeTimeout)

			resizeTimeout = setTimeout(->
				resizeTimeout = null
				resize()
			, 50)

		$window.on 'resize', throttledResize
		resize()

		# Clean up events
		scope.$on '$destroy', ->
			unbindMouse()
			$bar.off('mousedown mouseup')
			$window.off('resize', throttledResize)
			$body = $bar = null

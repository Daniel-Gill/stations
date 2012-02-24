class TurntableControls

    constructor: (@object, @target, @domElement, @idleMove, @setVolatile) ->
        if @domElement == undefined
            @domElement = document
        @distance = 50
        @bearing = 0
        @angle = 45
        @bearingSpeed = 0.01
        @angleSpeed = 0.01
        @zoomSpeed = -20
        @flipyz = false
        @domElement.addEventListener('mousemove', @mousemove, false)
        @domElement.addEventListener('mousedown', @mousedown, false)
        @domElement.addEventListener('mouseup', @mouseup, false)
        jQuery(@domElement).mousewheel(@mousewheel)

    # Called every frame
    update: (delta) ->
        @setCamera()

    # Places the camera in the correct location
    setCamera: ->
        # Work out the horizontal location from the bearing
        horizontal = new THREE.Vector3(Math.sin(@bearing), 0, -Math.cos(@bearing))
        # And the vertical location and distance from centre
        position = horizontal.normalize().multiplyScalar(Math.cos(@angle))
        position.y = Math.sin(@angle)
        position = position.multiplyScalar(@distance).addSelf(@target)
        @object.position = position
        @object.lookAt(@target)

    mousedown: (event) =>
        event.preventDefault()
        event.stopPropagation()
        @startX = event.clientX
        @startY = event.clientY
        @startBearing = @bearing
        @startAngle = @angle

    mousemove: (event) =>
        if @startX and @startY
            @bearing = @startBearing + (event.clientX - @startX) * @bearingSpeed
            @angle = Math.max(Math.min(@startAngle + (event.clientY - @startY) * @angleSpeed, Math.PI/2), -Math.PI/2)
            @setVolatile()
        else if @idleMove?
            @idleMove(event)

    mouseup: (event) =>
        event.preventDefault()
        event.stopPropagation()
        @startX = undefined
        @startY = undefined
        @startBearing = undefined
        @startAngle = undefined

    mousewheel: (event, delta) =>
        event.preventDefault()
        event.stopPropagation()
        console.log(event, delta)
        @distance = Math.min(Math.max(@distance + (delta * @zoomSpeed), 50), 500)
        @setVolatile()

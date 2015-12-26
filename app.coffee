# Import Sketch 3 files
$ = Framer.Importer.load "imported/mixcloudframer"

bg = new BackgroundLayer 
	backgroundColor: '#314359'

logincontainer = $.logincontainer
logincontainer.center()
logincontainer.states.add
	on:
		x: Screen.width / 2 - logincontainer.midX 
logincontainer.states.animationOptions = curve:"spring(200,15,0)"

inputsFirst = $.inputsfirst

inputsFirst.states.add
	off: 
		opacity: 0
		
inputsSecond = $.inputssecond
inputsSecond.opacity = 0

inputsSecond.states.add
	off:
		opacity: 1

left = $.left
left.states.add
	off:
		opacity: 0
left.states.animationOptions = curve:"spring(200,15,0)"

right = $.right


textInputLayer = new Layer 
	x:27
	y: $.Or.maxY + 108
	z: 1
	width:292
	height:40
	superLayer: right
	borderWidth: 1
	borderColor: "#D3D3D3"
					
textInputLayer.ignoreEvents = false

textInputLayer.states.add
	error:
		borderColor: "red"
			
textInputLayer.style = {"border" : "1px solid #D3D3D3"}

# This creates a text input and adds some styling in plain JS
inputElement = document.createElement("input")
inputElement.style["width"]  = "#{textInputLayer.width}px"
inputElement.style["height"] = "#{textInputLayer.height}px"
inputElement.style["font"] = "12px/22px Helvetica"
inputElement.style["-webkit-user-select"] = "text"
inputElement.style["padding-left"] = "20px"
inputElement.style["outline"] = "none"

inputType = "username"

# Set the value, focus and listen for changes
inputElement.placeholder = "Enter your username or email"
inputElement.type = "Username"
inputElement.value = ""
inputElement.focus()

error = () ->
	shake logincontainer
	textInputLayer.states.switch('error')
	
username = () ->
	$.left.states.switch('default')
	logincontainer.states.switch('default')
	inputsFirst.states.switch('default')
	inputsSecond.states.switch('default')
	textInputLayer.states.switch('default')
	this.placeholder = "Enter your username or email"
	inputElement.type = "username"
	
password = () ->
	$.left.states.switch('off')
	logincontainer.states.switch('on')
	inputsFirst.states.switch('off')
	inputsSecond.states.switch('off')
	this.placeholder = "Enter your password"
	inputElement.type = "password"

inputElement.onkeyup = (e) ->
	textInputLayer.states.switch('default')
	# if user presses enter/return
	if e.keyCode is 13
		# Set the textvalue
		textVal = inputElement.value
		# email verification 
		input = inputElement.value
		if input.indexOf("@") > 0
			input
			inputType = "password"
			if inputType is "password"
				password()
		else if inputType is "password"
			username()
			inputType = "username"
		else if inputType is "username"
			error()
		false
	
		# Clear the value
		inputElement.value = ""
					

textInputLayer._element.appendChild(inputElement)
$.btnreturn.on Events.Click, ->
	username()

# shake animation
shake = (view, times=5) ->
  i = 0
	
  right = new Animation
    layer: view
    properties: 
      x: view.x + 4
    curve: "bezier-curve"
    time: 0.08
		
  left = new Animation
    layer: view
    properties: 
      x: view.x - 4
    curve: "bezier-curve"
    time: 0.08

  right.on "end", ->
    if i < times
      left.start()
      i++
    else
      view.animate
        properties:
          rotation: 0
          x: view.x-5
        time: 0.1
				
  left.on "end", ->
    if i < times
      right.start()
      i++
    else
      view.animate
        properties:
          rotation: 0
          x: view.x+5
        time: 0.1
   
  right.start()





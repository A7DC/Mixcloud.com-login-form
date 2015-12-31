# sketch file
$ = Framer.Importer.load("imported/mixcloudframer@1x")

# import web fonts
Utils.insertCSS('@import url(https://fonts.googleapis.com/css?family=Open+Sans:600);')

# background layer
bg = new BackgroundLayer
	image: 'images/bg-dark.png'
	
bg.states.add
	loggedin:
		image: 'images/bg-mixcloud--logged-in.png'

# view positioning
view = $.view
view.x = 0
view.y = 142

viewEnd = new Animation
    layer: view
    properties:
        y: -view.height
    delay: 1
    curve: "spring-dho(800, 200, 10, 0.01)"
    
viewEnd.on Events.AnimationEnd, ->
	bg.states.switchInstant('loggedin')

view.states.add
	off:
		y: -view.height
		opacity: 0
view.states.animationOptions =
	curve:"spring(50,15,0)"

view.centerX()

$.btngroup.superLayer = view
$.btngroup.y = 330
$.btngroup.centerX()

# Create the title for the current view
viewHeading = new Layer
	width: view.width
	superLayer: view
	height: 40
	y: $.main.minY - 45
	backgroundColor: bg.backgroundColor
	html: "Choose how to login"

viewHeading.style =
	'font': '22px/16px Open Sans'
	'text-align': 'center'
	
viewHeading.states.add
	passwordHeading:
		html: "Welcome back,"
	userHeading:
		html: "Choose how to login"

# Create the input for username and password
textInputLayer = new Layer 
	x: 37
	y: $.or.maxY + 60
	width: 258
	height: 40
	superLayer: view
	borderWidth: 1
	borderColor: "#D3D3D3"
	
inputLabel = new Layer
	superLayer: view
	x: 37
	y: $.or.maxY + 80
	size: textInputLayer.size
	backgroundColor: 'rgba(0,0,0,0)'
	opacity: 0
	color: "#25292B"
	
inputLabel.states.add
	userNameLabel:
		scale: 0.91
		x: 8
		y: textInputLayer.y - 30
		opacity: 1
		html: "Username or email"
	passwordLabel:
		scale: 0.91
		x: 8
		y: textInputLayer.y - 30
		opacity: 1
		html: "Password"
	
inputLabel.style["font-family"] = "Open Sans"
inputLabel.style["font-size"] = "12px"	
inputLabel.style["padding"] = "7px 0 0 20px"	
		
textInputLayer.ignoreEvents = false

textInputLayer.states.add
	error:
		borderColor: "red"
			
textInputLayer.style = {"border" : "1px solid #D3D3D3"}

# This creates a text input and adds some styling in plain JS
inputElement = document.createElement("input")
inputElement.style["width"]  = "#{textInputLayer.width}px"
inputElement.style["height"] = "#{textInputLayer.height}px"
inputElement.style["font"] = "12px/22px Open Sans"
inputElement.style["-webkit-user-select"] = "text"
inputElement.style["padding-left"] = "20px"
inputElement.style["outline"] = "none"

inputType = "username"

# create submit button
buttonConfirm = new Layer
	superLayer: view
	size: textInputLayer.size
	y: textInputLayer.maxY + 20
	x: textInputLayer.x
	backgroundColor: '#D3D3D3'
	borderRadius: 2
	
buttonText = new Layer
	size: buttonConfirm.size
	superLayer: buttonConfirm
	html: 'Confirm'
	backgroundColor: buttonConfirm.backgroundColor
	color: 'rgba(0,0,0,0.5)'
	
buttonText.style =
	'padding': '8px 0 0 0'
	'text-align': 'center'
	'font': '14px/22px Open Sans'
	'font-weight': 'bold'
	
buttonText.states.add
	active:
		backgroundColor: '#589FC3'
		color: 'white'
	hidden:
		opacity: 0
	
buttonConfirm.states.add
	active:
		borderRadius: 40
		width: 40
		x: (view.width - 40) / 2
		backgroundColor: '#589FC3'
buttonConfirm.states.animationOptions =
    curve:"ease-in-out"
    delay: 0
    time: 0.4

checkmark = $.checkmark
checkmark.superLayer = buttonConfirm
checkmark.y = 100
checkmark.x = 10

checkmark.states.add
	active:
		y: 10
		opacity: 1
checkmark.states.animationOptions =
    curve:"spring(200,15,0)"

# moves facebook and 'or' section from view
userNameOptions = $.usernameoptions
userNameOptions.states.add
	off: 
		opacity: 0

# moves password section from view		
passwordHeader = $.header
passwordHeader.superLayer = view
passwordHeader.x = 1
passwordHeader.y = 0
passwordHeader.opacity = 0
passwordHeader.scale - 0.5
passwordHeader.centerX = 0.5
passwordHeader.centerY = 0.5
passwordHeader.states.add
	on:
		y: 0
		opacity: 1
		scale: 1
		
# return button
$.btnreturn.on Events.Click, ->
	username()
		 		
# Set the value, focus and listen for changes
inputElement.placeholder = "Enter your username or email"
inputElement.type = "Username"
inputElement.value = ""
inputElement.focus()

# when there's an error, shake!
error = () ->
	shake view
	textInputLayer.states.switch('error')

# username screen	
username = () ->
	viewHeading.states.switchInstant('userHeading')
	userNameOptions.states.switchInstant('default')
	textInputLayer.states.switch('default')
	inputElement.placeholder = "Enter your username or email"
	inputElement.type = "username"
	passwordHeader.states.switchInstant('default')
	
# password screen
password = () ->
	viewHeading.states.switchInstant('passwordHeading')
	userNameOptions.states.switchInstant('off')
	passwordHeader.states.switch('on')
	inputElement.placeholder = "Enter your password"
	inputElement.type = "password"
	textInputLayer.states.switch('default')

# when user is logged in	
loggedin = () ->
	buttonText.destroy()
	buttonConfirm.states.switch('active')
	checkmark.states.switch('active')
	buttonConfirm.on Events.AnimationEnd, ->
	viewEnd.start()

inputElement.onkeyup = (e) ->
	input = inputElement.value
	# returns input to default state when typing
	textInputLayer.states.switch('default')
	# if user presses enter/return
	if e.keyCode is 13
		# email verification 
		if input.indexOf("@") > 0	
			input
			inputType = "password"
			if inputType is "password"
				password()
				inputLabel.states.switch('default')
		else if inputType is "password"
			inputType = "password"
			if inputElement.value.length <= 6
				error()
			else
				loggedin()
		else if inputType is "username"
			error()
		false
		# Clear the value
		inputElement.value = ""
	
	# show/hide label based on input type and entry
	# ensure button is in an active or inactive state
	if inputType is "username"
		inputLabel.states.switchInstant('userNameLabel')
		if input.indexOf("@") > 0
			buttonText.states.switchInstant('active')
		else
			buttonText.states.switchInstant('default')
	if inputType is "password"
		inputLabel.states.switchInstant('passwordLabel')
		if inputElement.value.length >= 6
			buttonText.states.switchInstant('active')
		else 
			buttonText.states.switchInstant('default')
	if inputElement.value.length <= 0
		inputLabel.states.switchInstant('default')
	
textInputLayer._element.appendChild(inputElement)

# shake animation
shake = (main, times=5) ->
  i = 0
	
  right = new Animation
    layer: view
    properties: 
      x: view.x + 4
      rotationX: 7
    curve: "bezier-curve"
    time: 0.08
		
  left = new Animation
    layer: view
    properties: 
      x: view.x - 4
      rotationX: 7
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
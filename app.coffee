# sketch file
$ = Framer.Importer.load("imported/mixcloudframer@1x")

# import web fonts
Utils.insertCSS('@import url(https://fonts.googleapis.com/css?family=Open+Sans:600);')

# background layer
bg = new BackgroundLayer
	backgroundColor: '314359'

# view positioning
view = $.view
view.x = 0

# center the view
view.center()

# Create the title for the current view
viewHeading = new Layer
	width: view.width
	superLayer: view
	height: 40
	y: $.main.minY - 85
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
	y: $.or.maxY + 40
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
	# is not the correct colour. inspect later
	backgroundColor: '#589FC3'
	
buttonText = new Layer
	size: buttonConfirm.size
	superLayer: buttonConfirm
	html: 'Confirm'
	
buttonText.style =
	'padding': '8px 0 0 0'
	'text-align': 'center'
	'font': '14px/22px Open Sans'
	'font-weight': 'bold'
	
buttonText.states.add
	hidden:
		opacity: 0
	
buttonConfirm.states.add
	clicked:
		html: ''
		borderRadius: 40
		width: 40
		x: (view.width - 40) / 2
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
		 		
# Set the value, focus and listen for changes
inputElement.placeholder = "Enter your username or email"
inputElement.type = "Username"
inputElement.value = ""
inputElement.focus()

error = () ->
	shake view
	textInputLayer.states.switch('error')
	
username = () ->
	viewHeading.states.switchInstant('userHeading')
	userNameOptions.states.switchInstant('default')
	passwordHeader.states.switchInstant('default')
	textInputLayer.states.switch('default')
	this.placeholder = "Enter your username or email"
	inputElement.type = "username"
	
password = () ->
	viewHeading.states.switchInstant('passwordHeading')
	userNameOptions.states.switchInstant('off')
	passwordHeader.states.switch('on')
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
				inputLabel.states.switch('default')
		else if inputType is "password"
			buttonText.states.switchInstant('hidden')
			checkmark.states.switch('active')
			buttonConfirm.states.switch('clicked')
			inputType = "password"
			buttonConfirm.on Events.AnimationEnd, ->
				username()
				inputType = "username"
				this.states.switch('default')
				checkmark.states.switch('default')
				buttonText.states.switchInstant('default')
		else if inputType is "username"
			error()
		false
		# Clear the value
		inputElement.value = ""
	
	# show/hide label based on input type and entry
	if inputType is "username"
		inputLabel.states.switchInstant('userNameLabel')
	if inputType is "password"
		inputLabel.states.switchInstant('passwordLabel')
	if inputElement.value.length <= 0
		inputLabel.states.switchInstant('default')

textInputLayer._element.appendChild(inputElement)

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
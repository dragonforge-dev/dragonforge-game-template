extends Node

enum Type {
	XBox,
	Playstation,
	Nintendo,
	Unknown
}

## Processes gamepad right stick movement for a 3D camera look feature when it
## is on.[br]
## Turn this off if you are not using it to save processing cycles.
@export var right_stick_look: bool = true:
	set(value):
		right_stick_look = value
		set_process_unhandled_input(value)
## Right stick horizontal look sensitivity modifier for 3D camera controls.
@export var horizontal_look_sensitivity: float = 0.075
## Right stick vertical look sensitivity modifier for 3D camera controls.
@export var vertical_look_sensitivity: float = 0.0375
##● JOY_BUTTON_A = 0
##Game controller SDL button A. Corresponds to the bottom action button: Sony Cross, Xbox A, Nintendo B.
##● JOY_BUTTON_B = 1
##Game controller SDL button B. Corresponds to the right action button: Sony Circle, Xbox B, Nintendo A.
##● JOY_BUTTON_X = 2
##Game controller SDL button X. Corresponds to the left action button: Sony Square, Xbox X, Nintendo Y.
##● JOY_BUTTON_Y = 3
##Game controller SDL button Y. Corresponds to the top action button: Sony Triangle, Xbox Y, Nintendo X.
##● JOY_BUTTON_BACK = 4
##Game controller SDL back button. Corresponds to the Sony Select, Xbox Back, Nintendo - button.
##● JOY_BUTTON_GUIDE = 5
##Game controller SDL guide button. Corresponds to the Sony PS, Xbox Home button.
##● JOY_BUTTON_START = 6
##Game controller SDL start button. Corresponds to the Sony Options, Xbox Menu, Nintendo + button.
##● JOY_BUTTON_LEFT_STICK = 7
##Game controller SDL left stick button. Corresponds to the Sony L3, Xbox L/LS button.
##● JOY_BUTTON_RIGHT_STICK = 8
##Game controller SDL right stick button. Corresponds to the Sony R3, Xbox R/RS button.
##● JOY_BUTTON_LEFT_SHOULDER = 9
##Game controller SDL left shoulder button. Corresponds to the Sony L1, Xbox LB button.
##● JOY_BUTTON_RIGHT_SHOULDER = 10
##Game controller SDL right shoulder button. Corresponds to the Sony R1, Xbox RB button.
##● JOY_BUTTON_DPAD_UP = 11
##Game controller D-pad up button.
##● JOY_BUTTON_DPAD_DOWN = 12
##Game controller D-pad down button.
##● JOY_BUTTON_DPAD_LEFT = 13
##Game controller D-pad left button.
##● JOY_BUTTON_DPAD_RIGHT = 14
##Game controller D-pad right button.
##● JOY_BUTTON_MISC1 = 15
##Game controller SDL miscellaneous button. Corresponds to Xbox share button, PS5 microphone button, Nintendo Switch capture button.
## Stores XBox button icons based on the list above.
@export var xbox_button_images: Array[Texture2D]
## Stores Playstation button icons based on the list above.
@export var playstation_button_images: Array[Texture2D]
## Stores Nintendo button icons based on the list above.
@export var nintendo_button_images: Array[Texture2D]

##● JOY_AXIS_LEFT_X = 0
##Game controller left joystick x-axis. (RIGHT +)
##● JOY_AXIS_LEFT_Y = 1
##Game controller left joystick y-axis. (DOWN +)
##● JOY_AXIS_RIGHT_X = 2
##Game controller right joystick x-axis. (RIGHT +)
##● JOY_AXIS_RIGHT_Y = 3
##Game controller right joystick y-axis. (DOWN +)
##● JOY_AXIS_TRIGGER_LEFT = 4
##Game controller left trigger axis. (POSITIVE)
##● JOY_AXIS_TRIGGER_RIGHT = 5
##Game controller right trigger axis. (POSITIVE)
## Stores XBox positive joystick and trigger icons based on the list above.
@export var xbox_positive_joystick_images: Array[Texture2D]
## Stores Playstation positive joystick and trigger icons based on the list above.
@export var playstation_positive_joystick_images: Array[Texture2D]
## Stores Nintendo positive joystick and trigger icons based on the list above.
@export var nintendo_positive_joystick_images: Array[Texture2D]

##● JOY_AXIS_LEFT_X = 0
##Game controller left joystick x-axis. (LEFT -)
##● JOY_AXIS_LEFT_Y = 1
##Game controller left joystick y-axis. (UP -)
##● JOY_AXIS_RIGHT_X = 2
##Game controller right joystick x-axis. (LEFT -)
##● JOY_AXIS_RIGHT_Y = 3
##Game controller right joystick y-axis. (UP -)
## Stores XBox negative joystick icons based on the list above.
@export var xbox_negative_joystick_images: Array[Texture2D]
## Stores Playstation negative joystick icons based on the list above.
@export var playstation_negative_joystick_images: Array[Texture2D]
## Stores Nintendo negative joystick icons based on the list above.
@export var nintendo_negative_joystick_images: Array[Texture2D]

@onready var button_images: Dictionary = {
	Type.XBox: xbox_button_images,
	Type.Playstation: playstation_button_images,
	Type.Nintendo: nintendo_button_images
}
@onready var positive_joystick_images: Dictionary = {
	Type.XBox: xbox_positive_joystick_images,
	Type.Playstation: playstation_positive_joystick_images,
	Type.Nintendo: nintendo_positive_joystick_images
}
@onready var negative_joystick_images: Dictionary = {
	Type.XBox: xbox_negative_joystick_images,
	Type.Playstation: playstation_negative_joystick_images,
	Type.Nintendo: nintendo_negative_joystick_images
}


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X:
			Controller.look = Vector2(-event.axis_value * horizontal_look_sensitivity, Controller.look.y)
		if event.axis == JOY_AXIS_RIGHT_Y:
			Controller.look = Vector2(Controller.look.x, -event.axis_value * vertical_look_sensitivity)


## Gets the type of gamepad being used by the player. Assumes we want the
## first device unless another device number is passed.
#TODO: Add Steam controller
func get_gamepad_type(device: int = 0) -> Type:
	var name = Input.get_joy_name(device)
	if name.contains("XBOX"):
		return Type.XBox
	if name.contains("PS"):
		return Type.Playstation
	if name.contains("Nintendo"):
		return Type.Nintendo
	# Return a default of XBox because otherwise if the gamepad is incorrectly
	# detected (or none is connected) it will crash the game before it even starts.
	return Type.XBox


## Returns a human-readable name for a gamepad based on the type detected.
#TODO: Add Steam controller
func get_gamepad_name(device: int = 0) -> String:
	match(get_gamepad_type(device)):
		Type.XBox:
			return "XBox Gamepad"
		Type.Playstation:
			return "Playstation Gamepad"
		Type.Nintendo:
			return "Nintendo Gamepad"
	# This code will never get called, as get_controller_type defalts to XBOX is
	# it can't determine the controller.
	return "Unknown Gamepad"


## Returns the Texture2D representation of the gamepad event passed, based
## on the type of gamepad the player is using. Returns null if the 
## InputEvent passed is not a Joypad event.
func get_gamepad_icon(action: InputEvent, device: int = 0) -> Texture2D:
	var type: Type = get_gamepad_type(device)
	if action is InputEventJoypadButton:
		return button_images[type][action.button_index]
	elif action is InputEventJoypadMotion:
		if action.axis_value > 0:
			return positive_joystick_images[type][action.axis]
		else:
			var my_axis = action.axis
			return negative_joystick_images[type][my_axis]
	return

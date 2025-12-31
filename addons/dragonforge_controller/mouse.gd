@icon("res://addons/dragonforge_controller/assets/textures/icons/mouse.svg")
## Mouse Autoload
extends Node

## Look sensitivity modifier for 3D camera controls
@export var sensitivity: float = 0.0075
## ● MOUSE_BUTTON_NONE = 0[br]
## Enum value which doesn't correspond to any mouse button. This is used to initialize MouseButton properties with a generic state.[br]
## ● MOUSE_BUTTON_LEFT = 1[br]
## Primary mouse button, usually assigned to the left button.[br]
## ● MOUSE_BUTTON_RIGHT = 2[br]
## Secondary mouse button, usually assigned to the right button.[br]
## ● MOUSE_BUTTON_MIDDLE = 3[br]
## Middle mouse button.[br]
## ● MOUSE_BUTTON_WHEEL_UP = 4[br]
## Mouse wheel scrolling up.[br]
##● MOUSE_BUTTON_WHEEL_DOWN = 5[br]
##Mouse wheel scrolling down.[br]
##● MOUSE_BUTTON_WHEEL_LEFT = 6[br]
##Mouse wheel left button (only present on some mice).[br]
##● MOUSE_BUTTON_WHEEL_RIGHT = 7[br]
##Mouse wheel right button (only present on some mice).[br]
##● MOUSE_BUTTON_XBUTTON1 = 8[br]
##Extra mouse button 1. This is sometimes present, usually to the sides of the mouse.[br]
##● MOUSE_BUTTON_XBUTTON2 = 9[br]
##Extra mouse button 2. This is sometimes present, usually to the sides of the mouse.[br]
## Stores mouse button icons based on the list above.
@export var mouse_button_images: Array[Texture2D]


func _unhandled_input(event: InputEvent) -> void:
	if Controller.enable_3d_look and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		Controller.look = -event.relative * sensitivity


## Returns the Texture2D representation of the mouse button event passed.
## Returns null if the InputEvent is not a MouseButtonEvent.
func get_mouse_icon(action: InputEvent) -> Texture2D:
	if action is InputEventMouseButton:
		return mouse_button_images[action.button_index]
	return

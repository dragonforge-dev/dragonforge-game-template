extends Node


## Signals that there is a request to load the default keybindings shipped
## with the game. (I.E. what was set in the Godot Editor.)
signal restore_default_keybindings
signal show_control_hint(action: String, text: String)


## Enumerates the kinds of inputs that are possible.
enum LastInput {
	KEYBOARD_AND_MOUSE,
	GAMEPAD
}


## Stores the amount of movement in the x/y direction that the player is trying
## to look in a 3D game.
var look := Vector2.ZERO
## Stores the last input used by the player for UI interaction hint updates.
## Private so that it cannot be modified extrenally. This is a read-only value
## outside this singleton. (Or would be if GDScript enforced that.)
var _last_input_type := LastInput.KEYBOARD_AND_MOUSE
## For saving and loading the input map.
var _action_list: ActionList


## Loads any custom keybindings from disk and applies them to the InputMap.
func _ready() -> void:
	_action_list = ActionList.load_or_create()
	for action_name in _action_list.action_events:
		for event_name in _action_list.action_events[action_name]:
			_set_binding(action_name, _action_list.action_events[action_name][event_name])
	restore_default_keybindings.connect(_on_restore_default_keybindings)


## Updates the last input type for use throughout the game.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion or event is InputEventKey:
		_last_input_type = LastInput.KEYBOARD_AND_MOUSE
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_last_input_type = LastInput.GAMEPAD


## Returns the last input type used by the player.
func get_last_input_type() -> LastInput:
	return _last_input_type


## Returns the correct Texture2D representation of the action passed based on
## the last input type used by the player.
func get_action_icon(action_name: String) -> Texture2D:
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if get_last_input_type() == LastInput.KEYBOARD_AND_MOUSE:
			if event is InputEventKey:
				return Keyboard.get_key_icon(event)
			if event is InputEventMouse:
				return Mouse.get_mouse_icon(event)
		else:
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				return Gamepad.get_gamepad_icon(event)
	return null


## Sets the passed event for the given action in the InputMap and saves it to
## disk for loading the next time the game is loaded.
func rebind_action(action: String, event: InputEvent) -> void:
	_set_binding(action, event)
	_save_binding(action, event)


## Sets the passed event for the given action in the InputMap for the game.
## This can result in either an additional option or overriding of an existing 
## option.
##
## (E.G. if the action "move_up" was only mapped to the `W` key, passing in an
## InputEventKey event which presses the Up Arrow would overwrite the entry.
## However passing an InputEventJoypadMovementEvent of the left stick being
## moved up would add a new event.)
func _set_binding(action_to_remap: String, event: InputEvent) -> void:
	var events = InputMap.action_get_events(action_to_remap)
	for existing_event in events:
		if existing_event.get_class() == event.get_class():
			InputMap.action_erase_event(action_to_remap, existing_event)
			break
	InputMap.action_add_event(action_to_remap, event)


## Saves on disk the passed event for the passed action.
func _save_binding(action_name: String, event: InputEvent) -> void:
	var action: Dictionary
	if _action_list.action_events.has(action_name):
		action = _action_list.action_events[action_name]
	action[event_to_string(event)] = event
	_action_list.action_events[action_name] = action
	_action_list.save()


## Returns a string representation of the passed InputEvent. Returns a string
## of "Unknown" if the InputEvent was not listed here.
func event_to_string(event: InputEvent) -> String:
	if event is InputEventKey:
		return "InputEventKey"
	elif event is InputEventMouseButton:
		return "InputEventMouseButton"
	elif event is InputEventMouseMotion:
		return "InputEventMouseMotion"
	elif event is InputEventJoypadButton:
		return "InputEventJoypadButton"
	elif event is InputEventJoypadMotion:
		return "InputEventJoypadMotion"
	elif event is InputEventGesture:
		return "InputEventGesture"
	return "Unknown"


## Deletes the keybindings.tres file, resets the action_list variable
## to a default of empty, and then reloads all the settings the developer
## set in the inital game.
func _on_restore_default_keybindings() -> void:
	_action_list.delete()
	_action_list = ActionList.load_or_create()
	InputMap.load_from_project_settings()

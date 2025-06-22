@tool
extends EditorPlugin

const AUTOLOAD_GAME = "Game"
const UI_ACCEPT_ACTION = "ui_accept"
const BACK_BUTTON_ACTION = "back_button"
const SKIP_ACTION = "skip"
const PAUSE_ACTION = "pause"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_GAME, "res://addons/dragonforge_game_template/game.tscn")
	append_action(UI_ACCEPT_ACTION, JOY_BUTTON_A)
	add_action(BACK_BUTTON_ACTION, JOY_BUTTON_B, MOUSE_BUTTON_XBUTTON1, KEY_ESCAPE)
	add_action(SKIP_ACTION, JOY_BUTTON_B, MOUSE_BUTTON_LEFT, KEY_SPACE)
	add_action(PAUSE_ACTION, JOY_BUTTON_START, MOUSE_BUTTON_NONE, KEY_ESCAPE)
	#if get_node_or_null("/root/Sound") == null:
		#load Sound autoload
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_GAME)
	restore_action(UI_ACCEPT_ACTION)
	remove_action(BACK_BUTTON_ACTION)
	remove_action(SKIP_ACTION)
	remove_action(PAUSE_ACTION)
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")


func add_action(action: StringName, gamepad_button: JoyButton, mouse_button: MouseButton, key: Key) -> void:
	var input_map = {
		"deadzone": 0.2,
		"events": []
	}
	
	if gamepad_button != JOY_BUTTON_INVALID:
		var event_gamepad = InputEventJoypadButton.new()
		event_gamepad.button_index = gamepad_button
		event_gamepad.device = -1 # All devices
		input_map["events"].append(event_gamepad)
	
	if mouse_button != MOUSE_BUTTON_NONE:
		var event_mouse = InputEventMouseButton.new()
		event_mouse.button_index = mouse_button
		event_mouse.device = -1 # All devices
		input_map["events"].append(event_mouse)
	
	if key != KEY_NONE:
		var event_key = InputEventKey.new()
		event_key.physical_keycode = key
		input_map["events"].append(event_key)
	
	ProjectSettings.set_setting("input/" + action, input_map)
	ProjectSettings.save()


func remove_action(action: StringName) -> void:
	ProjectSettings.set_setting("input/" + action, null)
	ProjectSettings.save()


func append_action(action: StringName, gamepad_button: JoyButton) -> void:
	var event_gamepad = InputEventJoypadButton.new()
	event_gamepad.button_index = gamepad_button
	event_gamepad.device = -1 # All devices
	
	var input_map = ProjectSettings.get_setting("input/" + action)
	input_map["events"].append(event_gamepad)
	ProjectSettings.set_setting("input/" + action, input_map)
	ProjectSettings.save()


## Deletes the last action in the list, regardless of what it is.
## assumes that append_action() has added an event onto the list.
func restore_action(action: StringName) -> void:
	var input_map = ProjectSettings.get_setting("input/" + action)
	input_map["events"].resize(input_map["events"].size() - 1)
	ProjectSettings.set_setting("input/" + action, input_map)
	ProjectSettings.save()

extends VBoxContainer

@export var input_button_scene: PackedScene

var is_remapping = false
var action_to_remap = null
var remapping_button = null
## Add action names and the text you would like to show up in the UI here.
## Only actions added to this list will show up in the UI.
var input_actions = {
	"move_up": "Move Up",
	"move_down": "Move Down",
	"move_left": "Move Left",
	"move_right": "Move Right",
	"interact": "Interact"
}

func _ready() -> void:
	_create_action_list()
	Controller.restore_default_keybindings.connect(_create_action_list)


func _create_action_list() -> void:
	for item in get_children():
		remove_child(item)
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		
		_update_action_list_item(button, action)
		
		add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action) -> void:
	if not is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("KeyboardInputLabel").text = "Press key to bind..."
		button.find_child("KeyboardTextureRect").hide()


func _input(event) -> void:
	if is_remapping:
		if event is InputEventKey \
		or event is InputEventJoypadButton \
		or event is InputEventJoypadMotion \
		or event is InputEventMouseButton:
			Controller.rebind_action(action_to_remap, event)
			_update_action_list_item(remapping_button, action_to_remap)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()


func _update_action_list_item(button, action) -> void:
	var action_label = button.find_child("ActionLabel")
	action_label.text = input_actions[action]
	
	var keyboard_input_label  = button.find_child("KeyboardInputLabel")
	var keyboard_image  = button.find_child("KeyboardTextureRect")
	var mouse_image = button.find_child("MouseTextureRect")
	var controller_image = button.find_child("ControllerTextureRect")
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			keyboard_input_label.text = ""
			keyboard_image.texture = Keyboard.get_key_icon(event)
			keyboard_image.show()
		elif event is InputEventMouse:
			mouse_image.texture = Mouse.get_mouse_icon(event)
		elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
			controller_image.texture = Gamepad.get_gamepad_icon(event)

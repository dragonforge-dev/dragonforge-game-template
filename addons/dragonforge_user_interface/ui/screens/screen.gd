## A default screen that is tracked by the UI autoload. All buttons in the screen are automatically
## hooked up to play the click sound set up in the Sound autoload. It also allows you to set a
## default control for when the screen loads, and tracks the last button pressed for when a player
## returns to this screen.
@icon("res://addons/dragonforge_user_interface/assets/textures/icons/screen.svg")
class_name Screen extends Control

## The control that receives focus by default when starting.
@export var default_focused_control: Control

# For tracking the last focused button when traversing menus.
var _button_last_focused: BaseButton
# The button to use if no default button is set.
var _default_button_focus_fall_back: BaseButton


func _ready() -> void:
	hide()
	visibility_changed.connect(_on_visibility_changed)
	child_exiting_tree.connect(_on_control_removed)
	child_entered_tree.connect(_on_control_added)
	_connect_buttons(self)
	UI.register_screen(self)


func _on_visibility_changed() -> void:
	if visible:
		_set_focus()


func _on_control_added(node: Node) -> void:
	_connect_buttons(node)

func _on_control_removed(node: Node) -> void:
	_disconnect_buttons(node)


# Sets focus for a control for keyboard and gamepad users. Picks the last
# button that had focus, then the default if set, then defaults to the first
# button it finds on the screen.
func _set_focus() -> void:
	if _button_last_focused:
		_button_last_focused.grab_focus()
	elif default_focused_control:
		default_focused_control.grab_focus()
	elif _default_button_focus_fall_back:
		_default_button_focus_fall_back.grab_focus()


# Stores the currently selected button for focusing upon exiting and re-entering
# the screen. Only buttons are tracked, since to enter or exit a screen, you
# must typically be on a button.
func _on_button_focused(button: BaseButton) -> void:
	_button_last_focused = button


# Play the default button pressed sound stored in [Sound] (if [Sound] exists).
func _on_button_pressed() -> void:
	if get_tree().root.has_node("Sound"):
		var sound: Variant = get_tree().root.get_node("Sound")
		sound.play_ui_sound(sound.get_sound("button_pressed"))


# Connects any button in the passed node for the button click sound and for
# default focus. Does the same for any buttons farther down the tree.
func _connect_buttons(node: Node) -> void:
	for subnode in node.get_children():
		if subnode is BaseButton:
			if not _default_button_focus_fall_back:
				_default_button_focus_fall_back = subnode
			subnode.pressed.connect(_on_button_pressed)
			subnode.focus_entered.connect(_on_button_focused.bind(subnode))
		_connect_buttons(subnode)


# Disconnects any button the passed node for the button click sound and for
# default focus. Does the same for any buttons farther down the tree.
func _disconnect_buttons(node: Node) -> void:
	for subnode in node.get_children():
		if subnode is BaseButton:
			if _default_button_focus_fall_back == subnode:
				_default_button_focus_fall_back = null
			subnode.pressed.disconnect(_on_button_pressed)
			subnode.focus_entered.disconnect(_on_button_focused.bind(subnode))
		_disconnect_buttons(subnode)

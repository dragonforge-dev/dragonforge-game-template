extends Control
class_name Screen

enum Type {
	None,
	Splash,
	Start,
	Pause,
	Victory,
	Defeat,
	HUD,
	Settings,
	Audio,
	Video,
	MusicDisplay,
	Credits,
	Controls
}

@export var screen_type: Type
@export var background_music: Song
@export var show_sound: AudioStream
@export var hide_sound: AudioStream

var parent: Control
## If this is a menu screen, this screen will stay visible when a new screen is
## opened. Useful for menus that move submenus to the side. Default is off.
var visible_on_new_screen: bool = false
var _controls: Array[Control]
var _control_last_focused: Control
var _buttons: Array[Button]


func _ready() -> void:
	self.visible = false
	self.connect("visibility_changed", _onVisibilityChanged)
	self.connect("child_exiting_tree", _onChildExitingTree)
	self.connect("child_entered_tree", _onChildEnteredTree)
	_connect_controls(self)


func disable_controls(disable: bool = true) -> void:
	for control in _controls:
		control.disabled = disable
	if not disable:
		_set_focus()


## This function exists to be overridden in case we want to do things like
## animations or apply shaders before closing a screen.
func hide_screen() -> void:
	self.hide()


func _set_focus() -> void:
	if _control_last_focused != null:
		_control_last_focused.grab_focus()
	elif _controls.size() != 0:
		_controls[0].grab_focus()


func _onVisibilityChanged():
	if visible == true:
		_set_focus()
		if show_sound != null:
			Sound.play_ui_sound(show_sound)
		if background_music != null:
			Music.play(background_music)
	if visible == false:
		if hide_sound != null:
			Sound.play_ui_sound(hide_sound)
		if background_music != null:
			Music.pause()


func _connect_controls(node: Node):
	for subnode in node.get_children():
		if subnode is Button:
			_controls.append(subnode)
			_buttons.append(subnode)
			subnode.connect("pressed", _onButtonPressed)
			subnode.connect("focus_entered", _onControlFocusEntered.bind(subnode))
		if subnode is HSlider:
			_controls.append(subnode)
			subnode.connect("focus_entered", _onControlFocusEntered.bind(subnode))
		_connect_controls(subnode)


func _onButtonPressed() -> void:
	Sound.play_button_pressed_sound()


func _onControlFocusEntered(control: Control) -> void:
	_control_last_focused = control


func _onChildExitingTree(node: Node):
	for subnode in node.get_children():
		if subnode is Button:
			_controls.erase(subnode)
			_buttons.erase(subnode)
			subnode.disconnect("pressed", _onButtonPressed)
			subnode.disconnect("focus_entered", _onControlFocusEntered.bind(subnode))
		if subnode is HSlider:
			_controls.erase(subnode)
			subnode.disconnect("focus_entered", _onControlFocusEntered.bind(subnode))
		_onChildExitingTree(subnode)


func _onChildEnteredTree(node: Node):
	_connect_controls(node)

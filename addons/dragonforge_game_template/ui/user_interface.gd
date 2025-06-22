class_name UserInterface extends CanvasLayer


@export var override_button_press_sound: AudioStream

var _screens: Dictionary
var _current_screen: Screen.Type

@onready var background: ColorRect = $Background


func _ready() -> void:
	for screen in get_children():
		if screen is Screen:
			_screens[screen.screen_type] = screen
	if override_button_press_sound != null:
		Sound.default_button_pressed_sound = override_button_press_sound

	_connect_butttons(self)


func start() -> void:
	_screens[Screen.Type.Start].visible = true
	background.show()
	_current_screen = Screen.Type.Start


func hide_ui() -> void:
	background.hide()
	_screens[Screen.Type.Start].visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back_button"):
		_onScreenCloseRequest()


func _connect_butttons(parent: Node):
	for node in parent.get_children():
		if node is Button:
			if node.has_signal("open_screen"):
				node.connect("open_screen", _onScreenOpenRequest)
			if node.has_signal("close_screen"):
				node.connect("close_screen", _onScreenCloseRequest)
		_connect_butttons(node)


func _onScreenOpenRequest(screen: Screen.Type) -> void:
	if screen == Screen.Type.MusicDisplay:
		_screens[screen].show() #These just pop up
		return
	var current_screen = _screens[_current_screen]
	current_screen.disable_controls()
	if not current_screen.visible_on_new_screen:
		current_screen.hide()
	_screens[screen].parent = current_screen
	_screens[screen].show()
	_current_screen = screen


func _onScreenCloseRequest(screen: Screen.Type = Screen.Type.None) -> void:
	if _current_screen == Screen.Type.Splash:
		return
	var current_screen = _screens[_current_screen]
	if screen != Screen.Type.None: # We're overriding the default functionality here for Toggles
		current_screen = _screens[screen]
		current_screen.hide_screen()
		return
	var parent_screen = current_screen.parent
	if parent_screen != null:
		current_screen.hide_screen()
		parent_screen.disable_controls(false)
		# If we hid the screen above, show it.
		if not parent_screen.visible_on_new_screen:
			parent_screen.show()
		_current_screen = current_screen.parent.screen_type

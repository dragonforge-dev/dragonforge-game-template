extends Control

class_name UserInterface

@export var override_button_press_sound: AudioStream
#@export var bypass_splash_screens: bool = false
#@export var splash_screens: Array[SplashScreen]

var _screens: Dictionary
var _current_screen: Screen.Type
#var _current_splash_screen: int = 0

#@onready var game: Game = $Game
#@onready var menu: State = $Game/Menu
#@onready var splash_screen: State = $"Game/Splash Screen"


func _ready() -> void:
	for screen in get_children():
		if screen is Screen:
			_screens[screen.screen_type] = screen
	if override_button_press_sound != null:
		Sound.default_button_pressed_sound = override_button_press_sound

	# Bypass splash screens if bypass is on and we are in a debug version of the game. Can't bypass in a release version.
	#if (bypass_splash_screens and OS.is_debug_build()) or splash_screens.size() == 0:
		#_screens[Screen.Type.Start].visible = true
		#_current_screen = Screen.Type.Start
		#game.switch_state(menu)
	#else:
		#_current_screen = Screen.Type.Splash
		#for splash_screen in splash_screens:
			#splash_screen.connect("splash_complete", _onSplashComplete)
		#
		#splash_screens[_current_splash_screen].visible = true
		#game.switch_state(splash_screen)

	_connect_butttons(self)


func start() -> void:
	_screens[Screen.Type.Start].visible = true
	_current_screen = Screen.Type.Start


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back_button"):
		_onScreenCloseRequest()


#func _onSplashComplete() -> void:
	#splash_screens[_current_splash_screen].visible = false
	#_current_splash_screen += 1
	#if _current_splash_screen < splash_screens.size():
		#splash_screens[_current_splash_screen].visible = true
	#else:
		#_current_screen = Screen.Type.Start
		#_screens[Screen.Type.Start].visible = true


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
	else:
		$ConfirmationQuitDialog.show()

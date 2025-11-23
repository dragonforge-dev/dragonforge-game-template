extends Node

var _screens: Dictionary[String, Screen]
var _current_screen: Screen


## Registers a new screen to the UI autoload ensuring only one screen at a time
## is open. (Used by the [Screen] object.)
func register_screen(screen: Screen) -> void:
	_screens[screen.name] = screen


## Opens a new [Screen] and closes the currently open screen.
func open_screen(screen: Screen) -> void:
	if _current_screen:
		_current_screen.hide()
	_current_screen = screen
	_current_screen.show()


## Opens a new [Screen] by the screen's name and closes the currently open screen.
func open_screen_by_name(screen_name: String) -> void:
	if _current_screen:
		_current_screen.hide()
	_current_screen = _screens[screen_name]
	_current_screen.show()


## Opens a new [Screen] by the screen's name without closing the currently open screen.
func open_pop_up_by_name(screen_name: String) -> void:
	_screens[screen_name].show()


## Closes a [Screen] by the screen's name.
func close_screen_by_name(screen_name: String) -> void:
	_screens[screen_name].hide()

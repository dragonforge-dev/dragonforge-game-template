extends Node

signal complete

const SPLASH_SCREEN = "Splash Screen"

@export var active_splash_screens: Array[SplashScreen]

var _current_splash_screen: int = 0


func _ready() -> void:
	for splash_screen in active_splash_screens:
		splash_screen.splash_complete.connect(_on_splash_complete)


func start() -> void:
	if active_splash_screens.size() == 0:
		_all_splash_screens_complete()
		return
	active_splash_screens[_current_splash_screen].show()


func _on_splash_complete() -> void:
	active_splash_screens[_current_splash_screen].hide()
	_current_splash_screen += 1
	if _current_splash_screen < active_splash_screens.size():
		active_splash_screens[_current_splash_screen].show()
	else:
		_all_splash_screens_complete()


func _all_splash_screens_complete() -> void:
	complete.emit()
	queue_free()

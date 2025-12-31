@icon("res://addons/dragonforge_game_template/assets/textures/icons/icon_monochrome_dark_16x16.png")
class_name MainTemplate extends Node

## This is here in case we aren't allowing the player to skip the splash
## screens but we want to do so for testing. (See also
## [member GameStateSplashScreen.splash_screens_are_skippable].) It only affects
## debug builds of the game.
@export var bypass_splash_screens_during_debug: bool = false


func _ready() -> void:
	ready.connect(_on_ready)


func _on_ready() -> void:
	# GameStateMachine starts on Splash Screens by default.
	# This is here unless we aren't allowing the player to skip the splash
	# screens but we want to do so for testing.
	# We wait until the node is fully constructed before running this code to make
	# sure that the [GameStateMainMenu] is ready to listen.
	if (bypass_splash_screens_during_debug and OS.is_debug_build()) :
		Game.splash_screens_complete.emit()

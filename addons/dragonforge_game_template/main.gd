class_name Main extends Node

## This is here unless we aren't allowing the player to skip the splash
## screens but we want to do so for testing.
@export var bypass_splash_screens_during_debug: bool = false
## The first game level to load and attach to the UI's start button.
@export_file var starting_level: String


func _ready() -> void:
	ready.connect(_on_ready)


# GameStateMachine starts on Splash Screens by default.
# This is here unless we aren't allowing the player to skip the splash
# screens but we want to do so for testing.
# We wait until the node is fully constructed before running this code to make
# sure that the [GameStateMainMenu] is ready to listen.
func _on_ready() -> void:
	if (bypass_splash_screens_during_debug and OS.is_debug_build()) :
		Game.splash_screens_complete.emit()

# Main
extends Node

## The first game level to load and attach to the UI's start button. You can
## either paste in a path to the scene, or press the [b]Open a File[/b] dialog
## button to the right of the text field and browse to the starting scene.
@export_file var starting_level: String
## This is here in case we aren't allowing the player to skip the splash
## screens but we want to do so for testing. (See also
## [member GameStateSplashScreen.splash_screens_are_skippable].) It only affects
## debug builds of the game.
@export var bypass_splash_screens_during_debug: bool = false


func _ready() -> void:
	ready.connect(_on_ready)


func _on_ready() -> void:
	# Game is initalized and loads save data for the whole game before this even
	# gets created. But we have to make sure that everything is crated before
	# we can check this.
	Disk.load_game()
	if not Game.level_path:
		Game.level_path = starting_level

	# GameStateMachine starts on Splash Screens by default.
	# This is here unless we aren't allowing the player to skip the splash
	# screens but we want to do so for testing.
	# We wait until the node is fully constructed before running this code to make
	# sure that the [GameStateMainMenu] is ready to listen.
	if (bypass_splash_screens_during_debug and OS.is_debug_build()) :
		Game.splash_screens_complete.emit()

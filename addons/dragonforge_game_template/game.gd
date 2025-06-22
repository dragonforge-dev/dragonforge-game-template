extends Node

## Splash screens have completed or been skipped.
signal splash_screens_complete
## Tell a cutsene to start.
signal start_cutscene(cutscene: String)
## Current cutscene has finished.
signal cutscene_finished
## Load the passed level
signal load_level(level_name: String, player: Node, target_transition_area: String)

## Starts out false. Becomes true when a new game is started, or a game is loaded.
var game_in_progress = false


## Quits the game, after notifying all nodes, which allows save on quit functionality.
## This should be used instead of [method get_tree.quit]
func quit() -> void:
	print_rich("[color=red][b]QUIT GAME[/b][/color]")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


## Pauses or unpauses the game based on the boolean sent.
## [br]Convenience fucntion.
func pause_game(pause: bool = true) -> void:
	get_tree().paused = pause


## Returns whether or not the game is pasused.
## [br]Convenience fucntion.
func is_paused() -> bool:
	return get_tree().paused


# Handles logging if the game is paused or unpaused.
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			print_rich("[color=red][b]PAUSED[/b][/color]")
		NOTIFICATION_UNPAUSED:
			print_rich("[color=red][b]UNPAUSED[/b][/color]")
		NOTIFICATION_WM_CLOSE_REQUEST:
			print_rich("[color=red][b]CLOSE REQUEST RECEIVED[/b][/color]")

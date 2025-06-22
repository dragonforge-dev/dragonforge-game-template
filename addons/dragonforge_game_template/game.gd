extends Node

## Splash screens have completed or been skipped.
signal splash_screens_complete
## Tell a cutsene to start.
signal start_cutscene(cutscene: String)
## Current cutscene has finished.
signal cutscene_finished
## Load the passed level
signal load_level(level_name: String, player: Node, target_transition_area: String)

## Whether or not game is loaded.
var is_loaded: bool = false
## Starts out false. Becomes true when a new game is started, or a game is loaded. Saved to disk.
var in_progress: bool = false
## Path for loading the next level. Saved to disk.
var level_path: String


# Loading this before the game even initializes. Ultimately if there are multiple
# saves this won't work, but for this game jam (Craftpix 1 - 2025) it will work.
func _ready() -> void:
	Disk.load_game()


# Save game in progress status.
func save_node() -> Dictionary:
	var save_data: Dictionary = {
		"in_progress": in_progress,
		"level_path": level_path,
	}
	return save_data


# Load game in progress status.
func load_node(save_data: Dictionary) -> void:
	if not save_data.is_empty():
		in_progress = save_data["in_progress"]
		level_path = save_data["level_path"]


## Quits the game, after notifying all nodes, which allows save on quit functionality.
## This should be used instead of [method get_tree.quit]
func quit() -> void:
	print_rich("[color=red][b]QUIT GAME[/b][/color]")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


## Pauses or unpauses the game based on the boolean sent. Defaults to pausing the game.
## [br]Convenience method.
func pause(pause: bool = true) -> void:
	get_tree().paused = pause


## Unpauses the game.
## [br]Convenience method.
func unpause() -> void:
	pause(false)


## Returns whether or not the game is paused.
## [br]Convenience method.
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

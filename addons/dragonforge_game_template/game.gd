extends Node

signal game_state_entered(state_entered: String)
signal game_state_exited(state_exited: String)

## Starts out false. Becomes true when a new game is started, or a game is loaded.
var game_in_progress = false

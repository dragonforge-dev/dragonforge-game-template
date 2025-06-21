class_name GameStateMachine extends StateMachine


#func _ready() -> void:
	#super()
	#state_entered.connect(_on_game_state_entered)
	#state_exited.connect(_on_game_state_exited)
#
#
## Convoluted hoop jumping so game state changes can be accessed from anywhere
## by GameStateProcessor nodes.
#func _on_game_state_entered(state: State) -> void:
	#Game.game_state_entered.emit(state.name)
#
#
## Convoluted hoop jumping so game state changes can be accessed from anywhere
## by GameStateProcessor nodes.
#func _on_game_state_exited(state: State) -> void:
	#Game.game_state_exited.emit(state.name)

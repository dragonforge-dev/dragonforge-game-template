class_name GameStateProcessor extends Processor

## The name of the game state this node and all child nodes falls under.
## (Unless they have their own, different GameStateProcessor node.)
@export var state: String


func _ready() -> void:
	Game.state_entered.connect(_on_game_state_entered)
	Game.state_exited.connect(_on_game_state_exited)


# Run when a new game state is entered. Nothing happens unless the state entered
# matches the state variable in this GameStateProcessor.
func _on_game_state_entered(state_entered: String) -> void:
	if state_entered != state:
		return
	print_rich("[color=lime_green][b]%s[/b][/color] activated by [color=yellow]%s State[/color] for [color=ivory][b]%s[/b][/color] node" % [self.name, state, get_parent().name])


# Run when a game state is exited. Nothing happens unless the state exited
# matches the state variable in this GameStateProcessor.
func _on_game_state_exited(state_exited: String) -> void:
	if state_exited != state:
		return

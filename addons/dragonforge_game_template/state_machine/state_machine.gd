@icon("res://addons/dragonforge_game_template/assets/textures/icons/state_machine_64x64.png")
class_name StateMachine extends Node
## This node is intended to be generic and manage the various states in a game.
## If a SatteMachine has a state it should be added as a child node of the
## StateMachine.

signal state_entered(state_entered: State)
signal state_exited(state_exited: State)

## The initial State for the StateMachine
@export var starting_state: State
# The current State of the StateMachine. Initially defaults to the first node it
# finds beneath itself if starting_state is not defined.
@onready var _current_state: State


## Sets up all the States for this StateMachine, and monitors any states being
## added or removed to the machine by being added or removed as children nodes
## of this StateMachine instance.
func _ready() -> void:
	for state in get_children():
		if state is State:
			state.activate_state()
	self.connect("child_entered_tree", _on_state_added)
	self.connect("child_exiting_tree", _on_state_removed)
	if !starting_state:
		starting_state = self.get_child(0)
	_current_state = starting_state # Assign the new state we are transitioning to as the current state.
	_current_state.enter_state() # Run the enter code for the new current state.
	state_entered.emit(_current_state.name)


## Switch to the target state from the current state. Fails if:[br]
## 1. The StateMachine does not have the passed state.[br]
## 2. The StateMachine is already in that state.[br]
## 3. The current State won't allow a transition to happen.[br]
## 4. The target State won't allow a transition to happen (e.g. cooldown timers).
func switch_state(state: State) -> void:
	if not _machine_has_state(state): return # The StateMachine does not have the passed state.
	if _current_state == state: return # The StateMachine is already in that state.
	if not _current_state.can_transition: return # The current State won't allow a transition to happen.
	if not state.can_transition: return # The target State won't allow a transition to happen (e.g. cooldown timers).
	
	var previous_state = _current_state
	_current_state.exit_state() # Run the exit code for the current state.
	state_exited.emit(previous_state)
	
	_current_state = state # Assign the new state we are transitioning to as the current state.
	_current_state.enter_state() # Run the enter code for the new current state.
	state_entered.emit(_current_state)

# Returns whether or not the StatMachine has this state.
# (A StateMachine has a state if the state is a child node of the StateMachine.)
func _machine_has_state(state: State) -> bool:
	for element in get_children():
		if element == state:
			return true
	return false


# Activates a state.
# (Called when a node enters the tree as a child node of this StateMachine.)
# Accepts all nodes as an argument because this is called whenever a child node
# enters the tree.
func _on_state_added(node: Node) -> void:
	if not node is State:
		return
	node.activate_state()


# Deactivates a state.
# (Called when a child node of this StateMachine leaves the tree.)
# Accepts all nodes as an argument because this is called whenever a child node
# exits the tree.
func _on_state_removed(node: Node) -> void:
	if not node is State:
		return
	node.deactivate_state()

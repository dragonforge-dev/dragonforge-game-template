class_name GameStateInitialize extends State
# Inital state to load game resources while the Splash Screens are going

## The first game level to load and attach to the UI's start button.
@export var initial_scene_to_load: PackedScene


func enter_state() -> void:
	super()
	if initial_scene_to_load == null:
		return
	var scene = initial_scene_to_load.instantiate()
	get_owner().add_child.call_deferred(scene)


func exit_state() -> void:
	super()
	can_transition = false # Makes this one shot. Can't call it again.

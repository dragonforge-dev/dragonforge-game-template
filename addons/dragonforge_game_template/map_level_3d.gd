@icon("uid://gpt0r4tqaaem")
class_name MapLevel3D extends Node3D

@export var spawn_point: Node3D
@export var level_music: AudioStream

var player: CharacterBody3D


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func start(incoming_player: Node, incoming_spawn_position: String) -> void:
	show()
	if incoming_player == null:
		player = Game.player_scene.instantiate()
		player.set_physics_process(false)
		add_child(player)
	else:
		player = incoming_player
		player.set_physics_process(false)
		player.reparent(self)
	if incoming_spawn_position != "":
		for node in get_children():
			if node.name == incoming_spawn_position:
				print(incoming_spawn_position + " Found!")
				spawn_point = node
				break
	player.position = spawn_point.position
	player.set_physics_process(true)
	if level_music:
		Music.play(level_music)
	Disk.load_game()
	player.show()

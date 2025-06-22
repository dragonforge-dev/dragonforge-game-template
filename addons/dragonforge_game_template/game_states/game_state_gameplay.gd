class_name GameStateGameplay extends State

var level_path: String
var player: Node
var current_level: Node
var target_transition_area
var level_loading = false
var current_level_name: String = ""


func _activate_state() -> void:
	super()
	Game.load_level.connect(_on_load_level)
	set_process_input(true)
	

func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(level_path)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(0.5).timeout
		switch_state()


func _input(event: InputEvent) -> void:
	if not Game.is_paused:
		return
	if event.is_action_pressed("pause"):
		switch_state()
		get_viewport().set_input_as_handled()


func _enter_state() -> void:
	super()
	if level_loading:
		_start_level()


# Save the current level (which on changing level should be the one we just left)
func save_node() -> String:
	if current_level:
		return current_level.name.to_snake_case()
	return current_level_name


# Load the current saved level
func load_node(level_name: String) -> void:
	if level_name:
		current_level_name = level_name
		Game.level_path = level_name


func _on_load_level(level_name: String, player: Node, transition_area: String) -> void:
	set_process(true)
	if level_name.contains("uid://"):
		level_path = level_name
	else:
		level_path = "res://levels/" + level_name + ".tscn"
	self.player = player
	target_transition_area = transition_area
	level_loading = true


func _start_level() -> void:
	var scene = ResourceLoader.load_threaded_get(level_path)
	var new_level = scene.instantiate()
	add_child(new_level)
	if player != null:
		player.reparent(self)
	if new_level != current_level and current_level != null:
		current_level.queue_free()
	current_level = new_level
	current_level.start(player, target_transition_area)
	level_loading = false

class_name GameStateMainMenu extends State

## Music that plays whenever the main menu is visible.
@export var main_menu_music: Song
## The number of seconds after the song ends before it starts again.
@export_range(0.0, 300.0, 0.1, "suffix:seconds") var replay_countdown_time: float = 30.0
## The background to display whenever the main menu is visible.
@export var background: Control

@onready var user_interface: UserInterface = %UserInterface


func _activate_state() -> void:
	super()
	Game.splash_screens_complete.connect(switch_state)
	Music.pause_song_finished.connect(_on_pause_song_finished)
	set_process_input(true)
	user_interface.hide_ui()
	background.hide()


func _enter_state() -> void:
	super()
	Game.pause()
	if not Music.is_playing() and main_menu_music:
		main_menu_music.play()
	if not Game.is_loaded:
		background.show()
	user_interface.start()


func _exit_state() -> void:
	super()
	user_interface.hide_ui()
	background.hide()


func _input(event: InputEvent) -> void:
	if Game.is_paused():
		return
	if event.is_action_pressed("pause"):
		switch_state()
		get_viewport().set_input_as_handled()


func _on_pause_song_finished() -> void:
	await get_tree().create_timer(replay_countdown_time).timeout
	if Game.is_paused():
		main_menu_music.play()

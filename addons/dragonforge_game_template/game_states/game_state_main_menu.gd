class_name GameStateMainMenu extends State

## Music that plays whenever the main menu is visible.
@export var main_menu_music: Song
## The number of seconds after the song ends before it starts again.
@export_range(0.0, 300.0, 0.1, "suffix:seconds") var replay_countdown_time: float = 30.0
## The background to display whenever the main menu is visible.
@export var main_menu_background: Control
## The screen to load when the game is first launched and when a game isn't loaded.
@export var main_menu: Screen
## The screen to load when the game is paused.
@export var pause_menu: Screen


func _activate_state() -> void:
	super()
	Game.splash_screens_complete.connect(switch_state)
	Music.pause_song_finished.connect(_on_pause_song_finished)
	set_process_input(true)
	main_menu_background.hide()


func _enter_state() -> void:
	super()
	Game.pause()
	if not Music.is_playing() and main_menu_music:
		main_menu_music.play()
	if Game.is_loaded:
		UI.open_screen(pause_menu)
	else:
		main_menu_background.show()
		UI.open_screen(main_menu)


func _exit_state() -> void:
	super()
	UI._current_screen.hide()
	main_menu_background.hide()


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

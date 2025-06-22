class_name GameStateMainMenu extends State

@onready var user_interface: UserInterface = %UserInterface


func _activate_state() -> void:
	super()
	Game.splash_screens_complete.connect(switch_state)
	user_interface.hide_ui()


func _enter_state() -> void:
	super()
	Game.pause_game()
	user_interface.start()


func _exit_state() -> void:
	super()
	user_interface.hide_ui()
	Game.unpause_game()


func _input(event: InputEvent) -> void:
	if Game.is_paused:
		return
	if event.is_action_pressed("pause"):
		switch_state()
		get_viewport().set_input_as_handled()

class_name GameStateMainMenu extends State

@onready var background: ColorRect = %Background
@onready var user_interface: UserInterface = %UserInterface


func _activate_state() -> void:
	super()
	Game.splash_screens_complete.connect(switch_state)
	set_process_input(true)
	user_interface.hide_ui()
	background.hide()


func _enter_state() -> void:
	super()
	Game.pause()
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

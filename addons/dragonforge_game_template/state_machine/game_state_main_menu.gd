class_name GameStateMainMenu extends State

@onready var user_interface: UserInterface = %UserInterface

func enter_state() -> void:
	super()
	user_interface.start()

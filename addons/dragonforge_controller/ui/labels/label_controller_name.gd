extends Label

func _ready() -> void:
	text = Gamepad.get_gamepad_name()

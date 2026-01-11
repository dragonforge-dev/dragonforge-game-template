extends Button


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	Controller.restore_default_keybindings.emit()

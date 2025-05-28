extends Button


func _ready() -> void:
	self.connect("pressed", _on_button_pressed)


func _on_button_pressed() -> void:
	Controller.restore_default_keybindings.emit()

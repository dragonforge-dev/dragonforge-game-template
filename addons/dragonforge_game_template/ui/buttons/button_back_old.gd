extends Button


signal close_screen()


func _ready() -> void:
	self.connect("pressed", _onButtonPressed)


func _onButtonPressed() -> void:
	close_screen.emit()

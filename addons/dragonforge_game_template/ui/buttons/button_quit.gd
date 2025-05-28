extends Button


func _ready() -> void:
	self.connect("pressed", _onButtonPressed)


func _onButtonPressed() -> void:
	await get_tree().create_timer(0.25).timeout # Just enough time to hear the click sound.
	%ConfirmationQuitDialog.show()

class_name QuitButton extends Button


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	await get_tree().create_timer(0.25).timeout # Just enough time to hear the click sound.
	Game.quit()

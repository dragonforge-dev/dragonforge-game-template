class_name CloseScreenButton extends Button


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	UI.close_screen_by_name(owner.name)

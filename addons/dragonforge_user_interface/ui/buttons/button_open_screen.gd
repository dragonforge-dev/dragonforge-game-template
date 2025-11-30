class_name OpenScreenButton extends Button

## The name of the screen to open as it appears in the inspector.
@export var screen_to_open: String


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	UI.open_screen_by_name(screen_to_open)

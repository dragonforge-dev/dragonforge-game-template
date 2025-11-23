class_name ToggleScreenButton extends Button

## The name of the screen to toggle as it appears in the inspector.
@export var screen_to_toggle: String

func _ready() -> void:
	toggled.connect(_on_button_toggled)


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UI.open_pop_up_by_name(screen_to_toggle)
	else:
		UI.close_screen_by_name(screen_to_toggle)

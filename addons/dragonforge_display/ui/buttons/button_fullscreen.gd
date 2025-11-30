class_name FullscreenCheckButton extends CheckButton


func _ready() -> void:
	toggled.connect(_on_fullscreen_button_toggled)
	if Display.is_fullscreen():
		set_pressed_no_signal(true)


func _on_fullscreen_button_toggled(toggled_on: bool):
	Display.full_screen(toggled_on)

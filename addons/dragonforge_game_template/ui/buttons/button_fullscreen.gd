extends CheckButton
class_name CheckButtonFullscreen


func _ready() -> void:
	self.connect("toggled", _on_fullscreen_button_toggled)
	if Display.is_fullscreen():
		set_pressed_no_signal(true)


func _on_fullscreen_button_toggled(toggled_on: bool):
	Display.full_screen(toggled_on)

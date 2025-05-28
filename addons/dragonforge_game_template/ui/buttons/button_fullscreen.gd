extends CheckButton
class_name CheckButtonFullscreen


func _ready() -> void:
	self.connect("toggled", _on_fullscreen_button_toggled)
	if Video.is_fullscreen():
		set_pressed_no_signal(true)


func _on_fullscreen_button_toggled(toggled_on: bool):
	Video.full_screen(toggled_on)

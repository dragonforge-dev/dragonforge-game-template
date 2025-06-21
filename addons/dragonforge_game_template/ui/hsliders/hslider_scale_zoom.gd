extends HSlider


func _ready() -> void:
	self.value_changed.connect(_on_value_changed)
	Display.fullscreen.connect(_on_fullscreen_toggled)
	_on_fullscreen_toggled(Display.is_fullscreen())
	value = Display.get_scaling()


func _on_value_changed(new_value: float) -> void:
	Display.scale_zoom(new_value)


func _on_fullscreen_toggled(fullscreen_on: bool) -> void:
	if fullscreen_on:
		get_parent().show()
	else:
		get_parent().hide()
		set_value(1)

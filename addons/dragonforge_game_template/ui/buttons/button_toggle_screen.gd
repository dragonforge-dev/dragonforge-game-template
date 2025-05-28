extends Button

class_name ButtonToggleScreen


signal close_screen(screen: Screen.Type)
signal open_screen(screen: Screen.Type)


@export var screen_to_toggle: Screen.Type


func _ready() -> void:
	self.connect("toggled", _onButtonToggled)


func _onButtonToggled(toggled_on: bool) -> void:
	if toggled_on:
		open_screen.emit(screen_to_toggle)
	else:
		close_screen.emit(screen_to_toggle)

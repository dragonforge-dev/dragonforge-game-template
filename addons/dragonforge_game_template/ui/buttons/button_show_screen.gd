extends Button

class_name  ButtonShowScreen


signal open_screen(screen: Screen.Type)


@export var screen_to_open: Screen.Type


func _ready() -> void:
	self.connect("pressed", _onButtonPressed)


func _onButtonPressed() -> void:
	open_screen.emit(screen_to_open)

extends HBoxContainer

@onready var mouse_look_sensitivity_h_slider: HSlider = $"VBoxContainer2/Mouse Look Sensitivity HSlider"
@onready var gamepad_x_look_sensitivity_h_slider: HSlider = $"VBoxContainer2/Gamepad X Look Sensitivity HSlider"
@onready var gamepad_y_look_sensitivity_h_slider: HSlider = $"VBoxContainer2/Gamepad Y Look Sensitivity HSlider"
@onready var mouse_look_sensitivity_label: Label = $"VBoxContainer3/Mouse Look Sensitivity Label"
@onready var gamepad_x_look_sensitivity_label: Label = $"VBoxContainer3/Gamepad X Look Sensitivity Label"
@onready var gamepad_y_look_sensitivity_label: Label = $"VBoxContainer3/Gamepad Y Look Sensitivity Label"
@onready var reset_button: Button = $"../ResetButton"

func _ready() -> void:
	mouse_look_sensitivity_h_slider.value = Mouse.sensitivity
	mouse_look_sensitivity_label.text = str(Mouse.sensitivity)
	mouse_look_sensitivity_h_slider.value_changed.connect(_on_mouse_look_changed)
	
	gamepad_x_look_sensitivity_h_slider.value = Gamepad.horizontal_look_sensitivity
	gamepad_x_look_sensitivity_label.text = str(Gamepad.horizontal_look_sensitivity)
	gamepad_x_look_sensitivity_h_slider.value_changed.connect(_on_gamepad_x_look_changed)
	
	gamepad_y_look_sensitivity_h_slider.value = Gamepad.vertical_look_sensitivity
	gamepad_y_look_sensitivity_label.text = str(Gamepad.vertical_look_sensitivity)
	gamepad_y_look_sensitivity_h_slider.value_changed.connect(_on_gamepad_y_look_changed)
	
	reset_button.pressed.connect(_on_reset_button_pressed)


func _on_mouse_look_changed(new_value: float) -> void:
	Mouse.sensitivity = new_value
	mouse_look_sensitivity_label.text = str(new_value)


func _on_gamepad_x_look_changed(new_value: float) -> void:
	Gamepad.horizontal_look_sensitivity = new_value
	gamepad_x_look_sensitivity_label.text = str(new_value)


func _on_gamepad_y_look_changed(new_value: float) -> void:
	Gamepad.vertical_look_sensitivity = new_value
	gamepad_y_look_sensitivity_label.text = str(new_value)


func _on_reset_button_pressed() -> void:
	mouse_look_sensitivity_h_slider.value = 0.0075
	gamepad_x_look_sensitivity_h_slider.value = 0.075
	gamepad_y_look_sensitivity_h_slider.value = 0.0375

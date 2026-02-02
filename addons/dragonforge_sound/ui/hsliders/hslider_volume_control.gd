class_name VolumeControlHSlider extends HSlider

@export var bus: String

var gamepad_timer: Timer


func _ready() -> void:
	if AudioServer.get_bus_index(bus) == -1:
		hide()
		return
	value = Sound.get_bus_volume(bus)
	self.value_changed.connect(_on_value_changed)
	self.gui_input.connect(_on_gui_input)
	gamepad_timer = Timer.new()
	gamepad_timer.one_shot = true
	gamepad_timer.wait_time = 0.2
	add_child(gamepad_timer)


func _on_value_changed(new_value: float) -> void:
	Sound.set_bus_volume(bus, new_value)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		Sound.play_volume_confirm_sound(bus)
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		if gamepad_timer.is_stopped():
			Sound.play_volume_confirm_sound(bus)
			gamepad_timer.start()

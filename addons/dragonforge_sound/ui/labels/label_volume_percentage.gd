extends Label

@export var bus: String


func _ready() -> void:
	var value = Sound.get_bus_volume(bus)
	text = str(round(value * 100))
	Sound.volume_changed.connect(_on_volume_changed)


func _on_volume_changed(incoming_bus: String, value: float):
	if incoming_bus == bus:
		text = str(round(value * 100))

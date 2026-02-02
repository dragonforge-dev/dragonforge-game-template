extends Label

@export var bus: String


func _ready() -> void:
	if AudioServer.get_bus_index(bus) == -1:
		hide()
		return
	var value = Sound.get_bus_volume(bus)
	text = str(round(value * 100))
	Sound.volume_changed.connect(_on_volume_changed)


func _on_volume_changed(incoming_bus: String, value: float):
	if incoming_bus == bus:
		text = str(round(value * 100))

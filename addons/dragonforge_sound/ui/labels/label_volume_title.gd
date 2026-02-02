extends Label

@export var bus: String


func _ready() -> void:
	if AudioServer.get_bus_index(bus) == -1:
		hide()
		return

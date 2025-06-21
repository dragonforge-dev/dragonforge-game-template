extends Label


func _ready() -> void:
	Display.video_scale_changed.connect(_on_scale_changed)
	_on_scale_changed(Display.get_scaling())


func _on_scale_changed(value: float):
	text = str(round(value * 100)) + " %"

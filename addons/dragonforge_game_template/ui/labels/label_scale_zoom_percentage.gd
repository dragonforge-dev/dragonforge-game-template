extends Label


func _ready() -> void:
	Video.video_scale_changed.connect(_on_scale_changed)
	_on_scale_changed(Video.get_scaling())


func _on_scale_changed(value: float):
	text = str(round(value * 100)) + " %"

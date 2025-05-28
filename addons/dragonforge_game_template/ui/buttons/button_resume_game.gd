extends Button


func _ready() -> void:
	self.connect("pressed", _onButtonPressed)


func _onButtonPressed() -> void:
	get_owner().visible = false
	get_tree().paused = false

extends Button


func _ready() -> void:
	self.connect("pressed", _onButtonPressed)
	if Game.in_progress:
		text = "Resume Saved Game"


func _onButtonPressed() -> void:
	if Game.is_loaded:
		Game.unpause()
	else:
		Game.load_level.emit(Game.level_path, null, "")
		Game.in_progress = true
		Game.is_loaded = true
		text = "Resume Game"
		Disk.save_game()

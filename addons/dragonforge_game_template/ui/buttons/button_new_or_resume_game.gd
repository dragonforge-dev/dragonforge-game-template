extends Button


func _ready() -> void:
	self.connect("pressed", _onButtonPressed)
	if Game.in_progress:
		text = "Resume Saved Game"


func _onButtonPressed() -> void:
	if Game.is_loaded:
		# We are creating an action and sending it to be processed here so that
		# It will be processed by GameStateMainMenu. In effect we are sending
		# a puse signal and letting someone else pick it up. If we were to call
		# Game.pause() directly here, we would then have to tell GameStateMainMenu
		# That it needed to act like it was paused. This does that. This note is
		# here because I already tried to refactor this out once.
		var event = InputEventAction.new()
		event.action = "pause"
		event.pressed = true
		Input.parse_input_event(event)
	else:
		Game.load_level.emit(Game.level_path, null, "")
		Game.in_progress = true
		Game.is_loaded = true
		text = "Resume Game"
		Disk.save_game()

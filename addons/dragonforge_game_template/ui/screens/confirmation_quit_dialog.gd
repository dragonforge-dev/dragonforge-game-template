extends ConfirmationDialog


func _ready() -> void:
	connect("confirmed", _on_quit_confirmed)
	connect("canceled", _on_quit_canceled)


func _on_quit_confirmed() -> void:
	Game.quit()


func _on_quit_canceled() -> void:
	self.hide()

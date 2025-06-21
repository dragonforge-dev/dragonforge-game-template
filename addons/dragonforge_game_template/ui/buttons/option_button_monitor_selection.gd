extends OptionButton
class_name OptionButtonMonitorSelection


func _ready() -> void:
	if DisplayServer.get_screen_count() == 1:
		self.get_parent().hide()
		return
	for i in DisplayServer.get_screen_count():
		self.add_item(str(i+1),i+1)
	self.item_selected.connect(_on_monitor_selected)
	Display.window_moved_to_monitor.connect(_on_window_moved)
	selected = DisplayServer.window_get_current_screen()


func _on_monitor_selected(index: int) -> void:
	Display.select_monitor(index)


func _on_window_moved(new_monitor_id: int) -> void:
	selected = new_monitor_id

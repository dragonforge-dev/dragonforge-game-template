extends OptionButton
class_name OptionButtonResolutionSelection


var supported_resolutions: Array[Vector2i]
var current_resolution: Vector2i:
	set(value):
		current_resolution = value
		text = "%d x %d" % [current_resolution.x, current_resolution.y]


func _ready() -> void:
	current_resolution = get_window().get_size()
	var monitor_max_resolution = DisplayServer.screen_get_size()
	var i: int = 0
	for resolution in Display.RESOLUTIONS:
		if resolution <= monitor_max_resolution:
			self.add_item("%d x %d" % [resolution.x , resolution.y])
			supported_resolutions.append(resolution)
			i += 1
	_highlight_selection()
	
	self.item_selected.connect(_on_resolution_selected)
	Display.fullscreen.connect(_on_fullscreen_toggled)
	Display.resolution_changed.connect(_on_resolution_changed)
	
	if Display.is_fullscreen():
		disabled = true


func _on_resolution_selected(index: int) -> void:
	Display.set_resolution(supported_resolutions[index])


func _on_resolution_changed(new_resolution: Vector2i) -> void:
	if new_resolution != current_resolution:
		current_resolution = new_resolution


func _on_fullscreen_toggled(fullscreen_on: bool) -> void:
	current_resolution = get_window().get_size()
	if fullscreen_on:
		disabled = true
	else:
		disabled = false
		_highlight_selection()


func _highlight_selection() -> void:
	selected = -1
	for i in supported_resolutions.size():
		if supported_resolutions[i] == current_resolution:
			selected = i
	text = "%d x %d" % [current_resolution.x, current_resolution.y]

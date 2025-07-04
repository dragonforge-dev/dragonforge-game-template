extends Node

signal fullscreen(fullscreen_on: bool)
signal video_scale_changed(new_value: float)
signal window_moved_to_monitor(new_monitor_id: int)
signal resolution_changed(new_resolution: Vector2i)

const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(3840, 2160),
	Vector2i(2560, 1080),
	Vector2i(1920, 1080),
	Vector2i(1536, 864),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(1440, 900),
	Vector2i(1600, 900),
	Vector2i(1152, 648),
	Vector2i(1024, 600),
	Vector2i(800, 600),
	Vector2i(630, 500), # Added for Itch.io cover image screenshots
]

var active_monitor: int:
	set(value):
		active_monitor = value
		if active_monitor != null:
			window_moved_to_monitor.emit(active_monitor)
			Disk.save_setting(active_monitor, "Monitor Number")


func _ready() -> void:
	# Monitor Selection
	var returned_value = Disk.load_setting("Monitor Number")
	if returned_value == ERR_DOES_NOT_EXIST:
		active_monitor = DisplayServer.window_get_current_screen()
	else:
		active_monitor = returned_value
		select_monitor(active_monitor)
	
	# Resolution Functionality
	var current_resolution = Disk.load_setting("Current Resolution")
	if current_resolution is Vector2i:
		set_resolution(current_resolution)
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	# Fullscreen Functionality
	var fullscreen_value = Disk.load_setting("Fullscreen")
	if fullscreen_value is bool:
		full_screen(fullscreen_value)
	
	# Scale Zoom
	if is_fullscreen():
		var zoom = Disk.load_setting("Scale Zoom")
		if zoom:
			scale_zoom(zoom)


## Allows for non-standard window sizes. Also tracks changes to the monitor the
## screen is on - but only if the size of the window is changed.
func _on_window_size_changed() -> void:
	set_resolution(get_window().get_size())
	if DisplayServer.window_get_current_screen() != active_monitor:
		active_monitor = DisplayServer.window_get_current_screen()


## Turn fullscreen on/off.
func full_screen(on: bool) -> void:
	if on:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		var screen = DisplayServer.window_get_current_screen()
		get_window().mode = Window.MODE_WINDOWED
		DisplayServer.window_set_current_screen(screen) # We have to switch back to the screen we were just on (may be a bug)
		get_window().move_to_center()
	
	fullscreen.emit(on)
	resolution_changed.emit(get_window().get_size())
	
	Disk.save_setting(on, "Fullscreen")


## Returns whether fullscreen is currently on.
func is_fullscreen() -> bool:
	return get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN


## Set monitor resolution.
func set_resolution(resolution: Vector2i) -> void:
	get_window().set_size(resolution)
	get_window().move_to_center()
	Disk.save_setting(get_window().get_size(), "Current Resolution")
	resolution_changed.emit(resolution)


## Move the game to the passed monitor. (Only has an effect in fullscreen mode.)
func select_monitor(monitor_number: int) -> void:
	DisplayServer.window_set_current_screen(monitor_number)
	get_window().move_to_center()
	Disk.save_setting(monitor_number, "Monitor Number")


## Change the 3D scale zoom. (Only has an effect in fullscreen mode.)
func scale_zoom(zoom: float) -> void:
	get_viewport().set_scaling_3d_scale(zoom)
	video_scale_changed.emit(zoom)
	Disk.save_setting(zoom, "Scale Zoom")


### Get 3D scaling value.
func get_scaling() -> float:
	return get_viewport().scaling_3d_scale

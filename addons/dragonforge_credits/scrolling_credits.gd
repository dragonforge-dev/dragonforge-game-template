@icon("uid://cefdkgipseugo")
class_name ScrollingCredits extends ScrollContainer


## Each scene added will be displayed in order in the credits.
@export var credit_scenes: Array[PackedScene]
## Adjust how fast the credits scroll.
@export_range(1.0,5.0,0.1) var auto_scroll_speed: float = 1.0
## Expressed as a percentage of the screen height.
@export var separation_amount: float = 0.125
## Debug Option to allow you to scroll manually forwards and backwards while
## building the credits.
@export var manual_scroll_on: bool = false:
	set(value):
		manual_scroll_on = value
		if manual_scroll_on:
			mouse_filter = Control.MOUSE_FILTER_PASS
		else:
			mouse_filter = Control.MOUSE_FILTER_IGNORE


var credits_container: VBoxContainer


func _ready() -> void:
	if manual_scroll_on:
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	
	credits_container = VBoxContainer.new()
	credits_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	credits_container.add_theme_constant_override("separation", DisplayServer.window_get_size().y * separation_amount)
	add_child(credits_container)
	
	credits_container.add_child(_create_header_or_footer())
	
	for credit_scene in credit_scenes:
		var credit: Control = credit_scene.instantiate()
		credit.custom_minimum_size.y = DisplayServer.window_get_size().y
		credits_container.add_child(credit)
		
	
	credits_container.add_child(_create_header_or_footer())


func _process(delta: float) -> void:
	scroll_vertical += auto_scroll_speed


func _create_header_or_footer() -> Control:
	var spacer: Control = Control.new()
	spacer.custom_minimum_size.y = DisplayServer.window_get_size().y
	return spacer

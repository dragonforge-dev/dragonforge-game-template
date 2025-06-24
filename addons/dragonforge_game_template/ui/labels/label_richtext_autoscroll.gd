extends RichTextLabel


const DEFAULT_FONT_SIZE = 16
const HEIGHT_IN_LINES_AT_600 = 40

@export var autoscroll_speed = 40

@onready var original_text = text
@onready var original_height = size.y

func _ready() -> void:
	get_parent().connect("visibility_changed", _on_visibility_changed)
	self.connect("meta_clicked", _on_meta_clicked)
	self.visible = true
	set_process(false)


func _process(delta: float) -> void:
	if get_parent().visible == true:
		var current_resolution = get_window().get_size()
		if position.y + (size.y/2) + current_resolution.y/2 > 0:
			position.y -= autoscroll_speed * delta
			print("position.y (%s) + (size.y/2) (%s) + (current_resolution.y/2) %s = (%s)" % [position.y, size.y/2, current_resolution.y/2,  position.y + (size.y/2) + current_resolution.y])
		else:
			self.visible = false


func _on_visibility_changed():
	if get_parent().visible == true:
		self.visible = true
		print("Start scroll")
		text = original_text
		size.y = original_height
		var buffertext: String
		var screen_lines = get_viewport().size.y / DEFAULT_FONT_SIZE
		var height_in_lines = original_height / DEFAULT_FONT_SIZE
		var number_of_buffer_lines = height_in_lines / 8
		if screen_lines > HEIGHT_IN_LINES_AT_600:
			number_of_buffer_lines += (screen_lines - HEIGHT_IN_LINES_AT_600) / 2
		for line in (number_of_buffer_lines):
			buffertext += "\n"
		text = buffertext + text
		set_process(true)
	else:
		set_process(false)


func _on_meta_clicked(meta: Variant):
	OS.shell_open(str(meta))

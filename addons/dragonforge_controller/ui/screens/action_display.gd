## Intended to be used completely by signals.
class_name ActionDisplay extends CanvasLayer

var current_action

@onready var action_texture: TextureRect = %"Action Texture"
@onready var action_label: Label = %"Action Label"


func _ready() -> void:
	Controller.show_action_display.connect(_show_hint)
	Controller.hide_action_display.connect(_hide_hint)
	Controller.input_method_changed.connect(_on_input_type_changed)
	hide()


func _show_hint(action: String, message: String) -> void:
	current_action = action
	action_texture.texture = Controller.get_action_icon(current_action)
	action_label.text = message
	show()


func _hide_hint() -> void:
	hide()
	current_action = null


func _on_input_type_changed(last_input_type: Controller.LastInput) -> void:
	if current_action:
		action_texture.texture = Controller.get_action_icon(current_action, last_input_type)

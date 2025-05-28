extends Screen
class_name MenuScreenBurn


var _original_position
var burn_time: float = 1.0


var burn_material: ShaderMaterial = preload("res://assets/materials/dissolve_fire/dissolve_fire_2d.material")
var button_burn_material: ShaderMaterial = preload("res://assets/materials/dissolve_fire/dissolve_fire_2d_button.material")
var burn_sound: AudioStream = preload("res://assets/sound/sfx/burn/Fire Punch.wav")


func _onVisibilityChanged():
	visible_on_new_screen = true
	super()
	if visible == true:
		_show_screen()


func _show_screen() -> void:
	var new_position = self.position
	_original_position = self.position
	new_position.x += parent.size.x + parent.position.x
	self.scale = Vector2(0.5, 0.5)
	self.position.y = parent.position.y + ( (parent.size.y / 2) - (parent.size.y / 4) )
	self.position.x = parent.position.x + (parent.size.x / 4)
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2(1,1), 1.0)
	tween.tween_property(self, "position", new_position, 1.0)


func _reset_screen() -> void:
	self.hide()
	self.position = _original_position


func hide_screen() -> void:
	_apply_shader_material(self, burn_material)
	self.material.set("shader_parameter/Integrity", 1.0)
	var tween = create_tween()
	tween.set_parallel()

	if _buttons.size() != 0:
		_apply_button_shader_material(button_burn_material)
		_buttons[0].material.set("shader_parameter/Integrity", 1.0)
		tween.tween_property(_buttons[0], "material:shader_parameter/Integrity", 0, burn_time)

	tween.tween_property(self, "material:shader_parameter/Integrity", 0, burn_time)
	Sound.play_ui_sound(burn_sound)
	# Wait until the end of the effect, then reset everything.
	await get_tree().create_timer(burn_time).timeout
	_reset_screen()
	_apply_shader_material(self, null)
	if _buttons.size() != 0:
		_apply_button_shader_material(null)

func _apply_shader_material(node: Node, shader_material: ShaderMaterial) -> void:
	if node is not PanelContainerCutout and node is not Button:
		node.material = shader_material
	for subnode in node.get_children():
		_apply_shader_material(subnode, shader_material)

func _apply_button_shader_material(shader_material: ShaderMaterial) -> void:
	for node in _buttons:
		node.material = shader_material

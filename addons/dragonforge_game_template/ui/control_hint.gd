extends HBoxContainer


@onready var hint_texture: TextureRect = %HintTexture
@onready var hint_label: Label = %HintLabel
@onready var hint_animation_player: AnimationPlayer = %HintAnimationPlayer


func _ready() -> void:
	Controller.show_control_hint.connect(show_hint)


func show_hint(action: String, message: String):
	hint_animation_player.stop()
	hint_animation_player.play("FadeOutText")
	hint_label.text = message
	hint_texture.texture = Controller.get_action_icon(action)

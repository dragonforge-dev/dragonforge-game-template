@icon("res://addons/dragonforge_game_template/assets/textures/icons/splash_screen.svg")
class_name SplashScreen extends Screen

signal splash_complete

@export var timer: Timer
@export var video_player: VideoStreamPlayer
@export var animation_player: AnimationPlayer


func _on_timer_timeout() -> void:
	splash_complete.emit()


func _onVisibilityChanged():
	super()
	if visible == true:
		timer.start()
		if video_player != null:
			video_player.play()
		if animation_player != null and animation_player.has_animation("Show"):
			animation_player.play("Show")

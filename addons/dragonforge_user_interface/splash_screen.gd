## A screen for display upon starting the game. Typically either plays a video
## or an animation. The sound can optionally be muted if you want to play one
## contiguous opening theme.
@icon("res://addons/dragonforge_user_interface/assets/textures/icons/splash_screen.svg")
class_name SplashScreen extends Control

## Indicates that this splash screen is done playing. Tied directly to the
## display_time export variable.
signal splash_complete

const MUTED_BUS = &"Mute"
const SHOW = "Show"

## Check this to turn off splash screen sound to allow the playing of theme
## music on startup.
@export var mute_sound: bool = false
## The amount of time the splash screen should be shown.
@export var display_time: float = 1.0
## If a [VideoStreamPlayer] is placed here, it will automatically be run. Ignored if left blank.
@export var video_player: VideoStreamPlayer
## If an [AnimationPlayer] is placed here, it will automatically play the "Show" animation.
## Ignored if left blank.
@export var animation_player: AnimationPlayer


func _ready() -> void:
	hide()
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if visible == true:
		if video_player != null:
			if mute_sound:
				video_player.bus = MUTED_BUS
			video_player.play()
		if animation_player != null and animation_player.has_animation(SHOW):
			if mute_sound:
				for audio_stream_player in get_children():
					if audio_stream_player is AudioStreamPlayer:
						audio_stream_player.bus = MUTED_BUS
			animation_player.play(SHOW)
		await get_tree().create_timer(display_time).timeout
		splash_complete.emit()

@icon("res://addons/dragonforge_sound/assets/icons/sound-effect.svg")
class_name UISounds extends Resource

const ERROR_MISSING_SOUND_EFFECT = preload("res://addons/dragonforge_sound/resources/error_missing_sound_effect.tres")

## A list of sounds that can be played. Stroed in a resource that is local to
## the game so that it is easy to updated the Sound plugin and re-apply
## settings.
@export var sounds: Dictionary[String, AudioStream]

func get_sound(sound_name: String) -> AudioStream:
	if sounds.has(sound_name):
		return sounds[sound_name]
	else:
		return ERROR_MISSING_SOUND_EFFECT.stream

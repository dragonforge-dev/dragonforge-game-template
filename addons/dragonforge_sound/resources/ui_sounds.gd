@icon("res://addons/dragonforge_sound/assets/textures/icons/ui_sounds.svg")
## A list of sounds that can be played. Stored in a resource that is local to
## the game so that it is easy to updated the Sound plugin and re-apply
## settings.
class_name UISounds extends Resource

const IM_MISSING_SOMETHING = preload("uid://bs1qesstrghc8")

## A list of sounds that can be played. Stored in a resource that is local to
## the game so that it is easy to updated the Sound plugin and re-apply
## settings.
@export var sounds: Dictionary[String, AudioStream]


## Retrieve an AudioStream stored under the given name.
func get_sound(sound_name: String) -> AudioStream:
	if sounds.has(sound_name):
		return sounds[sound_name]
	else:
		return IM_MISSING_SOMETHING

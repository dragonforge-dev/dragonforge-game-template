@icon("res://addons/dragonforge_sound/assets/textures/icons/sound.svg")
## Sound Autoload
extends Node

## Emitted when the volume for a bus is changed.
signal volume_changed(audio_bus: String, new_value: float)

## Stores custom sounds for the UI Player that can be saved to a resource.
@export var ui_sounds: UISounds

# A sound player dedicated to Dialogue that is always active (so it can be used in cutscenes).
@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer
# The UISoundPlayer continues to work even if the game is paused.
@onready var ui_sound_player: AudioStreamPlayer = $UISoundPlayer
# This [AudioStreamPlayer] is only used to play volume confirm sounds, switching buses as needed.
@onready var volume_confirm_sound_player: AudioStreamPlayer = $VolumeConfirmSoundPlayer


# Loads any saved volume settings.
func _ready() -> void:
	for index in AudioServer.bus_count:
		var bus = AudioServer.get_bus_name(index)
		var value = Disk.load_setting(bus)
		if value:
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), value)
		if bus.contains("UI"):
			ui_sound_player.bus = bus
		if bus.contains("Dialog"):
			dialogue_player.bus = bus


## Returns the [AudioStream] from [member ui_sounds] that matches
## [param sound_name]. Returns null if nothing is found.
func get_sound(sound_name: StringName) -> AudioStream:
	return ui_sounds.get_sound(sound_name)


## Plays an [AudioStream] through the UI Sound Player which is always active.
func play_ui_sound(stream: AudioStream) -> void:
	ui_sound_player.stream = stream
	ui_sound_player.play()


## Plays the default volume confirm sound therough the passed bus.
## Used for confirming volume changes in the Audio settings menu.
func play_volume_confirm_sound(bus_name: String = "Master") -> void:
	volume_confirm_sound_player.bus = bus_name
	volume_confirm_sound_player.play()


## Plays an [AudioStream] through the Dialogue Player which is always active.
func play_dialogue(stream: AudioStream) -> void:
	if stream == null:
			return
	dialogue_player.set_stream(stream)
	dialogue_player.play()


## Sets the volume of the given bus using the float for the volume from
## 0.0 (off) to 1.0 (full volume). Also stores the value in the settings file.
func set_bus_volume(bus: String, new_value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), new_value)
	Disk.save_setting(new_value, bus)
	volume_changed.emit(bus, new_value)


## Returns the volume for the bus passed as a float from 0.0 (off) to
## 1.0 (full volume).
func get_bus_volume(bus: String) -> float:
	return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus))

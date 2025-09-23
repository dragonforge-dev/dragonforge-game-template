extends Node

signal volume_changed(audio_bus: String, new_value: float)

const ERROR_MISSING_SOUND_EFFECT = preload("res://addons/dragonforge_sound/resources/error_missing_sound_effect.tres")

## Default sound for when a button is pressed.
@export var button_pressed_sound: AudioStream
## Default sound for when the volume level is changed in the UI.
@export var volume_confirm_sound: AudioStream
## This bus must be created, or you must choose a different bus for music to play using Music.
@export var music_bus_name = "Music"
## This bus must be created, or you must choose a different bus for sound effects to work.
@export var sfx_bus_name = "SFX"
## This bus must be created, or you must choose a different bus for UI sound effects to work when the game is paused.
@export var ui_bus_name = "UI"
## This bus must be created, or you must choose a different bus for ambient sound effects to work.
@export var ambient_bus_name = "Ambient"

# Stores a reference for playing polyphonic sounds (more than one at the same time).
var sound_playback: AudioStreamPlaybackPolyphonic
# Stores a reference for playing polyphonic UI sounds (more than one at the same time).
var ui_playback: AudioStreamPlaybackPolyphonic

## A sound player dedicated to Dialogue.
@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer
## All sound effects go through this sound player unless they are for UI or played specifically
## through another AudioStreamPlayer instance.
@onready var sound_player: AudioStreamPlayer = $SoundPlayer
## The UISoundPlayer continues to work even if the game is paused.
@onready var ui_sound_player: AudioStreamPlayer = $UISoundPlayer


## Loads any saved volume settings and sets up the generic sound player for use.
func _ready() -> void:
	for index in AudioServer.bus_count:
		var bus = AudioServer.get_bus_name(index)
		var value = Disk.load_setting(bus)
		if not value == ERR_DOES_NOT_EXIST:
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), value)
	sound_player.play()
	sound_playback = sound_player.get_stream_playback()
	ui_sound_player.play()
	ui_playback = ui_sound_player.get_stream_playback()


## Plays an AudioStream through the SFX (Sound Effects) bus.
## Returns the UID of the playback stream as an int.
func play_sound_effect(sound: Resource) -> int:
	return play(sound, sfx_bus_name)


## Plays an AudioStream through the UI bus.
## Returns the UID of the playback stream as an int.
func play_ui_sound(sound: Resource) -> int:
	return play(sound, ui_bus_name)


## Plays the default click sound through the UI bus.
## Returns the UID of the playback stream as an int.
func play_button_pressed_sound() -> int:
	return play_ui_sound(button_pressed_sound)


## Plays the default volume confirm sound therough the passed bus.
## Used for confirming volume changes in a settings menu.
func play_volume_confirm_sound(bus_name: String = ui_bus_name) -> void:
	# TODO: Making a new AudioStreamPlayer each time because when it is passed
	# through the UISoundPlayer it only seems to use the Master or UI bus...
	# Failing code: return _play_polyphonic(ui_playback, volume_confirm_sound, bus_name)
	# Since polyphonice is causing other problems, a pooling solution for
	# AudioStreamPlayers may be necessary.
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.bus = bus_name
	audio_stream_player.stream = volume_confirm_sound
	audio_stream_player.play()
	await audio_stream_player.finished
	audio_stream_player.queue_free()


## Plays an AudioStream through the Ambient bus.
## Returns the UID of the playback stream as an int.
func play_ambient_sound(sound: Resource) -> int:
	return play(sound, ambient_bus_name)


## Plays an AudioStream through the Dialogue bus.
func play_dialogue(sound: AudioStream) -> void:
	if sound == null:
			return
	dialogue_player.set_stream(sound)
	dialogue_player.play()


## Returns the UID of the playback stream it uses to play the passed AudioStream
## on the given bus.
func play(sound: Resource, bus_name: String) -> int:
	if bus_name == ui_bus_name:
		return _play_polyphonic(ui_playback, sound, bus_name)
	else:
		return _play_polyphonic(sound_playback, sound, bus_name)


## Returns the UID of the playback stream it uses to play the passed AudioStream
## on the given bus using the passed AudioStreamPlaybackPolyphonic object.
func _play_polyphonic(playback: AudioStreamPlaybackPolyphonic, sound: Resource, bus: String) -> int:
	if sound is SoundEffect:
		return sound.play(bus)
	if sound is Song:
		sound.play()
		return -1
	if sound == null:
		push_error("Cannot play sound %s. AudioStream is null." % [sound])
		ERROR_MISSING_SOUND_EFFECT.play()
	return playback.play_stream(sound,
								0.0,
								0.0,
								1.0,
								AudioServer.PLAYBACK_TYPE_DEFAULT,
								bus
	)


## Stops the playback of a polyphonic sound given the UID of the sound playing.
func stop(uid: int) -> void:
	sound_playback.stop_stream(uid)


## Sets the volume of the given bus using the float for the volume from 
### 0.0 (off) to 1.0 (full volume).
func set_bus_volume(bus: String, new_value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), new_value)
	Disk.save_setting(new_value, bus)
	volume_changed.emit(bus, new_value)


## Returns the volume for the bus passed as a float from 0.0 (off) to 
## 1.0 (full volume).
func get_bus_volume(bus: String) -> float:
	return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus))

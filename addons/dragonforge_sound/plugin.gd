@tool
extends EditorPlugin

const AUTOLOAD_SOUND = "Sound"
const AUTOLOAD_MUSIC = "Music"
const RESOURCE = "Resource"
const ALBUM = "Album"
const SONG = "Song"
const SFX_PROJECT = "SFXProject"
const SOUND_EFFECT = "SoundEffect"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_SOUND, "res://addons/dragonforge_sound/sound.tscn")
	add_autoload_singleton(AUTOLOAD_MUSIC, "res://addons/dragonforge_sound/music.tscn")
	add_custom_type(ALBUM, RESOURCE, preload("res://addons/dragonforge_sound/resources/album.gd"), preload("res://addons/dragonforge_sound/assets/icons/album.png"))
	add_custom_type(SONG, RESOURCE, preload("res://addons/dragonforge_sound/resources/song.gd"), preload("res://addons/dragonforge_sound/assets/icons/song.svg"))
	add_custom_type(SFX_PROJECT, RESOURCE, preload("res://addons/dragonforge_sound/resources/sfx_project.gd"), preload("res://addons/dragonforge_sound/assets/icons/crate.svg"))
	add_custom_type(SOUND_EFFECT, RESOURCE, preload("res://addons/dragonforge_sound/resources/sound_effect.gd"), preload("res://addons/dragonforge_sound/assets/icons/sound-effect.svg"))
	ProjectSettings.set_setting(
		"audio/buses/default_bus_layout",
		"res://addons/dragonforge_sound/resources/sound_component_bus_layout.tres",
	)
	ProjectSettings.save()
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for Audio Bus changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_MUSIC)
	remove_autoload_singleton(AUTOLOAD_SOUND)
	remove_custom_type(ALBUM)
	remove_custom_type(SONG)
	remove_custom_type(SFX_PROJECT)
	remove_custom_type(SOUND_EFFECT)
	ProjectSettings.set_setting(
		"audio/buses/default_bus_layout",
		"res://addons/dragonforge_sound/resources/default_audio_bus_layout.tres",
	)
	ProjectSettings.save()
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for Audio Bus changes to be removed. [color=ivory][b]Project -> Reload Current Project[/b][/color]")

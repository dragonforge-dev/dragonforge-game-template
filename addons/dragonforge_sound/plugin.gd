@tool
extends EditorPlugin

const AUTOLOAD_SOUND = "Sound"
const AUTOLOAD_MUSIC = "Music"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_SOUND, "res://addons/dragonforge_sound/sound.tscn")
	add_autoload_singleton(AUTOLOAD_MUSIC, "res://addons/dragonforge_sound/music.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_MUSIC)
	remove_autoload_singleton(AUTOLOAD_SOUND)

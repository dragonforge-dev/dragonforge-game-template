@tool
extends EditorPlugin

const AUTOLOAD_DISPLAY = "Video"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_DISPLAY, "res://addons/dragonforge_display/display.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_DISPLAY)

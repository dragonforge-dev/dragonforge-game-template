@tool
extends EditorPlugin

const AUTOLOAD_UI = "UI"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_UI, "res://addons/dragonforge_user_interface/ui.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_UI)

@tool
extends EditorPlugin


const AUTOLOAD_DISK = "Disk"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_DISK, "res://addons/dragonforge_disk/disk.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_DISK)

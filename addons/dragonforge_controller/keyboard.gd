extends Node


@onready var icon_path: String = "res://addons/dragonforge_controller/assets/key_icons/"


## Returns the Texture2D representation of the keyboard key event passed
func get_key_icon(event: InputEventKey) -> Texture2D:
	var keyname = event.as_text().trim_suffix(" (Physical)")
	keyname = keyname.trim_prefix("Kp ")
	var filename = icon_path + "keyboard_" + keyname + "_outline.png"
	if ResourceLoader.exists(filename):
		return load(filename)
	return

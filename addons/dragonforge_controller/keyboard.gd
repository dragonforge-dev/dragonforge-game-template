extends Node

const icon_path = "res://addons/dragonforge_controller/assets/key_icons/"


## Returns the Texture2D representation of the keyboard key event passed
func get_key_icon(event: InputEventKey) -> Texture2D:
	var keyname = event.as_text().trim_suffix(" (Physical)")
	keyname = keyname.trim_prefix("Kp ").to_lower()
	var filename = icon_path + "keyboard_" + keyname + "_outline.png"
	return load(filename)

@tool
extends EditorPlugin

const AUTOLOAD_GAMEPAD = "Gamepad"
const AUTOLOAD_MOUSE = "Mouse"
const AUTOLOAD_KEYBOARD = "Keyboard"
const AUTOLOAD_CONTROLLER = "Controller"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_GAMEPAD, "res://addons/dragonforge_controller/gamepad.tscn")
	add_autoload_singleton(AUTOLOAD_MOUSE, "res://addons/dragonforge_controller/mouse.tscn")
	add_autoload_singleton(AUTOLOAD_KEYBOARD, "res://addons/dragonforge_controller/keyboard.tscn")
	add_autoload_singleton(AUTOLOAD_CONTROLLER, "res://addons/dragonforge_controller/controller.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_CONTROLLER)
	remove_autoload_singleton(AUTOLOAD_KEYBOARD)
	remove_autoload_singleton(AUTOLOAD_MOUSE)
	remove_autoload_singleton(AUTOLOAD_GAMEPAD)

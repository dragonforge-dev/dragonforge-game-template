@tool
extends EditorPlugin

const AUTOLOAD_GAME = "Game"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_GAME, "res://addons/dragonforge_game_template/game.tscn")
	#if get_node_or_null("/root/Sound") == null:
		#load Sound autoload

func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_GAME)

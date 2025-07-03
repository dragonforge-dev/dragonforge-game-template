# Game Configuration
@tool
class_name GameConfiguration extends Node

const MAIN_SCENE_SETTING = "application/run/main_scene"
const DEFAULT_AUTOLOAD_MAIN_SCENE = "res://addons/dragonforge_game_template/main.tscn"


## Copy "res://addons/dragonforge_game_template/game.tscn" to somewhere in your project.
## Anything you add to it will not be overwritten by updates to this plugin.
## Select the scene as the game_scene variable, and the plugin will use your scene
## instead of the default scene. Clearing this field will set it back to the default Game
## scene.
## [br][br][b][color=red]NOTE:[/color][/b] You must disable and re-enable the plugin for changes to
## this variable to have any effect. You do not need to reload the project for this change.
@export_file("*.tscn") var game_scene:
	set(value):
		if value and not value.contains("null"):
			game_scene = load(value).resource_path
		else:
			game_scene = null
		ProjectSettings.set_setting("application/config/autoload_game_scene", game_scene)
		ProjectSettings.save()
## Copy "res://addons/dragonforge_game_template/main.tscn" to somewhere in your project.
## Anything you add to it will not be overwritten by updates to this plugin.
## Select the scene as the main_scene variable, and the plugin will use your scene
## instead of the default scene. Clearing this field will set it back to the default Main
## scene.
## [br][br][b]NOTE:[/b] This is no different than setting the value in [b]Project Settings -> Run[/b], however
## setting it here will retain the value if you update or disable/re-enable the plugin.
@export_file("*.tscn") var main_scene:
	set(value):
		if value and not value.contains("null"):
			main_scene = load(value).resource_path
			ProjectSettings.set_setting("application/config/autoload_main_scene", main_scene)
			ProjectSettings.set_setting(MAIN_SCENE_SETTING, main_scene)
		else:
			main_scene = null
			ProjectSettings.set_setting("application/config/autoload_main_scene", null)
			ProjectSettings.set_setting(MAIN_SCENE_SETTING, DEFAULT_AUTOLOAD_MAIN_SCENE)
		ProjectSettings.save()

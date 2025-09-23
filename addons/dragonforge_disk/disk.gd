#TODO: Add unit tests.
extends Node

const SETTINGS_PATH = "user://configuration.settings"
const SAVE_GAME_PATH = "user://game.save"

## If this value is On, save_game() will be called when the player quits the game.
@export var save_on_quit: bool = false

var configuration_settings: Dictionary
var game_information: Dictionary
var is_ready = false


func _ready() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		configuration_settings = _load_file(SETTINGS_PATH)
	ready.connect(func(): is_ready = true)


func _notification(what) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST: #Called when the application quits.
			if save_on_quit:
				save_game()


## Returns true if the save was successful, otherwise false.
## Calls every node added to the Persist Global Group to save data. Works by
## calling every node in the group and running its `save_node()` function, then
## storing everything in the save file. If a node is in the group, but didn't
## implement the `save_node()` function, it is skipped.
func save_game() -> bool:
	var saved_nodes = get_tree().get_nodes_in_group("Persist")
	for node in saved_nodes:
		# Check the node has a save function.
		if not node.has_method("save_node"):
			print("Setting node '%s' is missing a save_node() function, skipped" % node.name)
			continue
		
		game_information[node.name] = node.save_node()
		print("Saving Info for %s: %s" % [node.name, game_information[node.name]])
	return _save_file(game_information, SAVE_GAME_PATH)


## Call this to call the `load_node()` function for every node in the Persist
## Global Group. The save game, if it exists, will be loaded from disk and the
## values propagated to the game objects.
func load_game() -> void:
	game_information = _load_file(SAVE_GAME_PATH)
	if game_information.is_empty():
		return
	var saved_nodes = get_tree().get_nodes_in_group("Persist")
	for node in saved_nodes:
		# Check the node has a load function.
		if not node.has_method("load_node"):
			print("Setting node '%s' is missing a load_node() function, skipped" % node.name)
			continue
		# Check if we have information to load for the value
		if game_information.has(node.name):
			print("Loading Info for %s: %s" % [node.name, game_information[node.name]])
			node.load_node(game_information[node.name])


## Stores the passed data under the indicated setting catergory.
func save_setting(data: Variant, category: String) -> void:
	configuration_settings[category] = data
	_save_file(configuration_settings, SETTINGS_PATH)


## Returns the stored data for the passed setting category.
func load_setting(category: String) -> Variant:
	if !is_ready:
		if FileAccess.file_exists(SETTINGS_PATH):
			configuration_settings = _load_file(SETTINGS_PATH)
	if configuration_settings.has(category):
		return configuration_settings[category]
	return ERR_DOES_NOT_EXIST


## Takes data and serializes it for saving.
func _serialize_data(data: Variant) -> String:
	return JSON.stringify(data)


## Takes serialized data and deserializes it for loading.
func _deserialize_data(data: String) -> Variant:
	var json = JSON.new()
	var error = json.parse(data)
	if error == OK:
		return json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())
	return null


func _save_file(save_information: Dictionary, path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print("File '%s' could not be opened. File not saved." % path)
		return false
	file.store_var(save_information)
	return true


func _load_file(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		print("File '%s' does not exist. File not loaded." % path)
		var return_value: Dictionary = {}
		return return_value
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_var()

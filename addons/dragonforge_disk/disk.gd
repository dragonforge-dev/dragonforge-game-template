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


## To add a value to be saved, add a node to the "Persist" Global Group on
## the Nodes tab. Then implement save_node() and load_node() functions.
## The first function should return a value to store, and the second should
## use that value to load the information. Make sure the load function has a
## await Signal(self, "ready") line at the top so it doesn't try to load values
## before the node exists. If you need to store multiple values, use a
## dictionary or changes later will result in save/load errors.
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


func load_game() -> void:
	game_information = _load_file(SAVE_GAME_PATH)
	if game_information == null:
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


## To add a setting to be saved, implement save_setting() functions. It should
## return a value to store. If you need to store multiple values, use a
## dictionary or any later changes will result in save/load errors.
## Call this function using Setting.save_setting(self)
## NOTE: The node name must be unique or settings will get overwritten.
func save_setting(data: Variant, category: String) -> void:
	configuration_settings[category] = data
	_save_file(configuration_settings, SETTINGS_PATH)


## To add a setting to be loaded, implement a load_setting() function. It should
## use the passed value(s) to configure the node. Make sure the load function
## has an await Signal(self, "ready") line at the top so it doesn't try to load 
## values before the node exists.
## Call this function using Setting.load_setting(self)
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
		return
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_var()

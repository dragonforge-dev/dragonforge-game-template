class_name ActionList extends Resource


const KEYBINDING_PATH = "user://keybindings.tres"


@export var action_events: Dictionary = {}


func save() -> void:
	ResourceSaver.save(self, KEYBINDING_PATH)


static func load_or_create() -> ActionList:
	var resource: ActionList
	if ResourceLoader.exists(KEYBINDING_PATH):
		resource = load(KEYBINDING_PATH) as ActionList
	else:
		resource = ActionList.new()
	return resource


static func delete() -> void:
	DirAccess.remove_absolute(KEYBINDING_PATH)

@icon("uid://dfg5nnhnk86wv")
class_name GenericSection extends VBoxContainer

@export var section_name: String
@export var label_settings: LabelSettings
## A list of contributor names for this section, followed by their role
@export var contributors: Dictionary[String, String]

var name_container: VBoxContainer
var role_container: VBoxContainer


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_theme_constant_override("separation", 10)
	
	_create_title_label()
	_create_columns()


func _create_title_label() -> void:
	var category_header_label_settings: LabelSettings = label_settings.duplicate_deep()
	category_header_label_settings.font_size = label_settings.font_size * 3
	
	var category_label: Label = Label.new()
	category_label.name = section_name
	category_label.label_settings = category_header_label_settings
	category_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	category_label.text = section_name
	add_child(category_label)


func _create_columns() -> void:
	var h_box_container: HBoxContainer = HBoxContainer.new()
	h_box_container.add_theme_constant_override("separation", 30)
	h_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(h_box_container)
	
	name_container = VBoxContainer.new()
	name_container.alignment = BoxContainer.ALIGNMENT_END
	h_box_container.add_child(name_container)
	
	role_container = VBoxContainer.new()
	role_container.alignment = BoxContainer.ALIGNMENT_END
	h_box_container.add_child(role_container)
	
	for key in contributors:
		_add_contributor(key, contributors[key])


func _add_contributor(name: String, role: String) -> void:
	var name_label: Label = Label.new()
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	name_label.label_settings = label_settings
	name_label.text = name
	name_container.add_child(name_label)
	
	var role_label: Label = Label.new()
	role_label.label_settings = label_settings
	role_label.text = role
	role_container.add_child(role_label)
	

@icon("uid://edvr286ell1v")
class_name MusicSection extends VBoxContainer

@export var section_name: String = "Music"
@export_dir var music_folder
@export var label_settings: LabelSettings
# Number of columns for displaying songs
@export var columns: int = 2

var song_container: GridContainer


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_theme_constant_override("separation", 50)
	
	_create_title_label()
	_create_song_container()
	_process_music()


func _create_title_label() -> void:
	var category_header_label_settings: LabelSettings = label_settings.duplicate_deep()
	category_header_label_settings.font_size = label_settings.font_size * 3
	
	var category_label: Label = Label.new()
	category_label.name = section_name
	category_label.label_settings = category_header_label_settings
	category_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	category_label.text = section_name
	add_child(category_label)


func _create_song_container() -> void:
	song_container = GridContainer.new()
	song_container.name = "Song Container"
	song_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	song_container.add_theme_constant_override("h_separation", 100)
	song_container.add_theme_constant_override("v_separation", 100)
	song_container.columns = columns
	add_child(song_container)


func _process_music() -> void:
	if not music_folder:
		push_error("music_folder not set.")
	var dir: DirAccess = DirAccess.open(music_folder)
	if not DirAccess.dir_exists_absolute(music_folder):
		return
	_process_folder(dir)


func _process_folder(dir: DirAccess) -> void:
	var path = dir.get_current_dir() + "/"
	var file_list: PackedStringArray = ResourceLoader.list_directory(path)
	for file in file_list:
		if (file.contains(".ogg") or file.contains(".wav") or file.contains(".mp3")) and not file.contains(".import"):
			var song_display: SongDisplay = SongDisplay.new(load(path + file), label_settings)
			song_display.name = file.to_snake_case().trim_suffix(".mp3").trim_suffix(".ogg").trim_suffix(".wav").capitalize()
			song_container.add_child(song_display)
	
	var folder_list = dir.get_directories()
	for folder in folder_list:
		dir.change_dir(folder)
		_process_folder(dir)
		dir.change_dir("..")

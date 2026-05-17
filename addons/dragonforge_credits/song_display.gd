@icon("uid://dueivh05iivlw")
class_name SongDisplay extends VBoxContainer

@export var song: AudioStream
@export var label_settings: LabelSettings

var title_label_settings: LabelSettings
var tags: Dictionary


func _init(song: AudioStream = null, label_settings: LabelSettings = null) -> void:
	if song:
		self.song = song
	if label_settings:
		self.label_settings = label_settings


func _ready() -> void:
	title_label_settings = label_settings.duplicate_deep()
	title_label_settings.font_size = int(label_settings.font_size * 1.33)
	alignment = BoxContainer.ALIGNMENT_CENTER
	add_theme_constant_override("separation", 0)
	_create_song_title()
	_create_line("composer", "Written by ")
	_create_line("artist", "Performed by ")
	_create_line("publisher", "Published by ")


func _create_song_title() -> void:
	var label: Label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.label_settings = title_label_settings
	label.text = "\"" + _get_song_title().to_upper() + "\""
	label.name = "Title"
	add_child(label)


func _create_line(tag: String, prefix: String) -> void:
	var tag_value = _get_tag(tag)
	if tag_value.is_empty():
		return
	else:
		var label: Label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.label_settings = label_settings
		label.text = prefix + tag_value
		label.name = tag.capitalize()
		add_child(label)


func _get_song_title() -> String:
	var return_value = _get_tag("title")
	
	if return_value.is_empty():
		return song.resource_path.get_file().to_snake_case().trim_suffix(".mp3").trim_suffix(".ogg").trim_suffix(".wav").capitalize()
	
	return return_value


func _get_tag(tag_name: String) -> String:
	var return_value = ""
	
	if not song:
		return return_value

	if not tags and (song is AudioStreamOggVorbis or song is AudioStreamWAV):
		tags = song.get_tags()

	if tags.has(tag_name):
		return_value = tags[tag_name]
	
	return return_value

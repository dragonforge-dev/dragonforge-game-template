@tool
@icon("res://addons/dragonforge_sound/assets/textures/icons/song.svg")
## A resource to retrieve song information more easily.
class_name Song extends Resource

## The [AudioStream] information is pulled from, if it exists.
@export var stream: AudioStream:
	set(value):
		stream = value
		_populate_song_info()
## The song's title. If metadata is not set, or the [AudioStream] does not
## support reading tags, a humanized version of the filename is used.
@export var title: String
## The song's artist, or alternately, album_artist, if either metadata is set.
## It is recommended to use [AudioStreamOggVorbis] for this feature.
@export var artist: String
## The song's album, if the metadata is set. It is recommended to use
## [AudioStreamOggVorbis] for this feature.
@export var album: String


func _populate_song_info() -> void:
	if stream == null:
		title = ""
		artist = ""
		album = ""
		return
	
	if stream is AudioStreamOggVorbis or stream is AudioStreamWAV:
		var tags: Dictionary = stream.get_tags()
		if tags.has("title"):
			title = tags["title"]
		else:
			title = stream.resource_path.get_file().to_snake_case().trim_suffix(".ogg").trim_suffix(".wav").capitalize()
		if tags.has("artist"):
			artist = tags["artist"]
		elif tags.has("album_artist"):
			artist = tags["album_artist"]
		if tags.has("album"):
			album = tags["album"]
	elif title.is_empty():
		title = stream.resource_path.get_file().to_snake_case().trim_suffix(".ogg").trim_suffix(".wav").capitalize()


## Returns the title, artist and album for the currently playing song as BBCode
## if they are stored in the metadata of the song and the stream is of type
## [AudioStreamOggVorbis] or [AudioStreamWAV]. Otherwise just returns the song
## title based on the name of the file. If [Color] values are passed for title,
## artist, or album they will be used in the returend BBCode. Otherwise, they
## will default to white.
func get_song_info_as_bbcode(title_color: Color = Color.WHITE, artist_color: Color = Color.WHITE, album_color: Color = Color.WHITE) -> String:
	var return_string: String = "[color=" + title_color.to_html(false) + "]" + title + "[/color] "
	if artist:
		return_string += "by [color=" + artist_color.to_html(false) + "]" + artist + "[/color] "
	if album:
		return_string += "from [color=" + album_color.to_html(false) + "]" + album + "[/color]"
	
	return return_string


## Returns the title, artist and album for the currently playing song if they
## are stored in the metadata of the song and the stream is of type
## [AudioStreamOggVorbis] or [AudioStreamWAV]. Otherwise just returns the song
## title based on the name of the file.
func get_song_info_as_text() -> String:
	var return_string: String = title + " "
	if artist:
		return_string += "by " + artist + " "
	if album:
		return_string += "from " + album
	
	return return_string

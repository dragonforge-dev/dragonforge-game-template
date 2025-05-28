@icon("res://addons/dragonforge_sound/assets/icons/song.svg")
class_name Song extends Resource


## The AudioStream containing the music track.
@export var song: AudioStream
## The human readable name of the song.
@export var title: String
## The album information for the song.
@export var album: Album


## Play this song in the Music player.
func play() -> void:
	Music.play(song)
	Music.now_playing.emit(self)


## Return the album name or a string saying it is unknown.
func get_album_name() -> String:
	return _get_album_info("name")


## Return the album artist or a string saying it is unknown.
func get_album_artist() -> String:
	return _get_album_info("artist")


## Return a hyperlink to the album or a string saying it is unknown.
func get_album_link() -> String:
	return _get_album_info("link")


# Helper function that calls the appropriate "get" function to retrieve album
# information, and returns a string no matter what to avoid null errors.
# Returns "No Album Info" if not album info is provided.
func _get_album_info(attribute: String) -> String:
	if album == null:
		return "No Album Info"
	else:
		var function = Callable(album, "get_" + attribute)
		return function.call()

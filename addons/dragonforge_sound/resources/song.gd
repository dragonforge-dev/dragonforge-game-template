@icon("res://addons/dragonforge_sound/assets/icons/song.svg")
class_name Song extends Resource

# TODO: This is here because the compiler wouldn't recognize the Music.Fade Enum at runtime.
# Ints have been assigned to both so that the values pass through.
# Should be a way to get it working so this doesn't have to be duplicated.
enum Fade {
	##Not intended to be used, but will function the same as NONE.
	DEFAULT = 0,
	##No fading. The current song (if any) is stopped and this one is started.
	NONE = 1,
	## The previous song (if any) is stopped, and this one fades in.
	IN = 2,
	## The previous song fades out and this one is started from the beginning after the fade is complete.
	OUT = 3,
	## The previous song fades out while this song fades in over the fade_time.
	CROSS = 4,
	## The previous song (if any) fades out completely first using the fade_time, then this song fades in over the fade_time.
	OUT_THEN_IN = 5
}

# TODO: This is here because the compiler wouldn't recognize the Music.DEFAULT_FADE_TIME const at runtime.
const DEFAULT_TRANSITION_TIME := 4.0 # The time it takes to fade in/out in seconds

## The AudioStream containing the music track.
@export var song: AudioStream
## The human readable name of the song.
@export var title: String
## The album information for the song.
@export var album: Album
## Sets the fade transition used when playing this song.[br][br]
##[b]NOTE:[/b] Has [i]no[/i] effect when this song stops playing. To fade a
## song out without playing another song call Music.stop(fade = true)
@export var play_transition: Fade = Fade.NONE
## The amount of time in seconds the transition fade effect is applied.[br]
## Has no effect if play_transition is set to NONE.
@export var transition_time: float = DEFAULT_TRANSITION_TIME


## Play this song in the Music player.
## If fade is set to DEFAULT, then whatever is set as the song's Music.Fade
## value will be used (which defaults to NONE). Otherwise it will use the value
## passed to it.
func play(fade = Fade.DEFAULT, fade_time = transition_time) -> void:
	if fade == Fade.DEFAULT:
		fade = play_transition
	Music.play(song, fade, fade_time)
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

extends Node

signal now_playing(song: Song)

@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	now_playing.connect(_on_now_playing)


## Plays an AudioStream through the music channel. If a Song resource is passed,
## the Song's own play() method is called (which calls this method with the
## embedded AudioStream and sends out the now_playing signal.)
func play(song: Resource) -> void:
	if song is Song:
		song.play()
	if song is not AudioStream:
		return
	music_player.set_stream(song)
	music_player.play()


## Stops the music player.
func stop() -> void:
	music_player.stop()


## Pauses the currently playing music.
## Returns the playback position where the stream was paused as a float.
func pause() -> float:
	music_player.stream_paused = true
	return music_player.get_playback_position()


## Unpauses the currently queued music.
func unpause() -> void:
	music_player.stream_paused = false


## Returns whether or not music is currently paused.
func is_paused() -> bool:
	return music_player.stream_paused


## Returns whether or not music is currently playing.
func is_playing() -> bool:
	return music_player.playing


## Prints to the log the details of the song currently playing when a new song
## is started. Handles situations where not all information for the song has
## been set.
func _on_now_playing(song: Song) -> void:
	if song.title.is_empty():
		song.title = song.song.resource_path.get_file()
	if song.album == null:
		print_rich("Song Playing: [color=lawn_green]%s[/color]" % [song.title])
	else:
		print_rich("Song Playing: [color=lawn_green][b]%s[/b][/color] by [color=cornflower_blue]%s[/color]" % [song.title, song.get_album_artist()])
		var album_name = song.get_album_name()
		if song.album.link.is_empty():
			album_name = "[color=cornflower_blue]" + album_name + "[/color]"
		else:
			var url = "[url=" + song.get_album_link() +"]"
			album_name = "[color=light_sky_blue]" + url + album_name + "[/url][/color]"
		print_rich("Album: %s" % album_name)

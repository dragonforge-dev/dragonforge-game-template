@icon("res://addons/dragonforge_sound/assets/icons/music.svg")
## Music Autoload
extends Node

signal now_playing(song: Song)
signal add_song_to_playlist(song: Song)
signal song_finished()
signal pause_song_finished()

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

const MUTE_VOLUME_DECIBAL := -80.0 # To mute the audio player
const DEFAULT_FADE_TIME := 4.0 # The time it takes to fade in/out in seconds

var music_player: AudioStreamPlayer

@onready var game_music_player: AudioStreamPlayer = $GameMusicPlayer
@onready var paused_game_music_player: AudioStreamPlayer = $PausedGameMusicPlayer


func _ready() -> void:
	now_playing.connect(_on_now_playing)
	game_music_player.finished.connect(func(): song_finished.emit())
	paused_game_music_player.finished.connect(func(): pause_song_finished.emit())
	if get_tree().is_paused():
		music_player = paused_game_music_player
	else:
		music_player = game_music_player


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			music_player = paused_game_music_player
		NOTIFICATION_UNPAUSED:
			music_player = game_music_player


## Plays an AudioStream through the music channel. If a Song resource is passed,
## the Song's own play() method is called (which calls this method with the
## embedded AudioStream and sends out the now_playing signal.)
## Fading uses the value passed. (Default is NONE.)
func play(song: Resource, fade: Fade = Fade.NONE, fade_time: float = DEFAULT_FADE_TIME) -> void:
	if song is Song:
		song.play(fade, fade_time)
	if song is not AudioStream:
		return
	
	match fade:
		Fade.NONE:
			music_player.set_stream(song)
			music_player.play()
		Fade.IN:
			music_player.set_stream(song)
			_fade_in(fade_time)
		Fade.OUT:
			_fade_out(music_player, fade_time)
			await get_tree().create_timer(fade_time).timeout
			music_player.set_stream(song)
			music_player.play()
		Fade.CROSS:
			var temp_player := AudioStreamPlayer.new()
			add_child(temp_player)
			temp_player.set_stream(music_player.stream)
			temp_player.play(music_player.get_playback_position())
			_fade_out(temp_player, fade_time)
			music_player.stop()
			music_player.set_stream(song)
			_fade_in(fade_time)
			await get_tree().create_timer(fade_time).timeout
			temp_player.queue_free()
		Fade.OUT_THEN_IN:
			_fade_out(music_player, fade_time)
			await get_tree().create_timer(fade_time).timeout
			music_player.set_stream(song)
			_fade_in(fade_time)
		_:
			music_player.set_stream(song)
			music_player.play()


## Stops the currently playing song. If fade_out is true, it fades out the
## currently playing song over the fade_time passed (default is 2 seconds).
func stop(fade_out: bool = false, fade_time: float = DEFAULT_FADE_TIME) -> void:
	if !is_playing():
		return
	if fade_out:
		_fade_out(music_player, fade_time)
	else:
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


# Fades in a new song using the passed fade_time. The Song or AudioStream must
# be set outside this function.
func _fade_in(fade_time: float) -> void:
	music_player.set_volume_db(MUTE_VOLUME_DECIBAL)
	music_player.play()
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var saved_music_bus_volume = Sound.get_bus_volume(Sound.music_bus_name)
	tween.tween_property(music_player, "volume_db", saved_music_bus_volume, fade_time)


# Fades out the currently playing song on the passed player using the passed
# fade_time. This is a separate function so that it can be called on a temporary
# player for crossfading.
func _fade_out(player: AudioStreamPlayer, fade_time: float) -> void:
	if !player.playing:
		return
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(player, "volume_db", MUTE_VOLUME_DECIBAL, fade_time)
	await get_tree().create_timer(fade_time).timeout
	tween.kill()
	player.stop()
	player.volume_db = Sound.get_bus_volume(Sound.music_bus_name) # saved_music_bus_volume


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

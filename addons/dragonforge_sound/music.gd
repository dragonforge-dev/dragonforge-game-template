@icon("res://addons/dragonforge_sound/assets/textures/icons/music.svg")
## Music Autoload
extends Node

## Emitted when a new song starts.
signal song_started
## Emitted when a song is stopped.
signal song_stopped
## Emitted when a song is not looped and finishes without being stopped externally.
signal song_finished
## Emitted when the pause menu song is not looped and finishes without being stopped externally.
signal pause_song_finished
## Emitted when a song is faded out, and the fade out finishes.
signal fade_out_finished

enum Fade {
	## Not intended to be used, but will function the same as NONE.
	DEFAULT = 0,
	## No fading. The current song (if any) is stopped and this one is started.
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
const MUSIC_BUS = "Music"

var music_player: AudioStreamPlayer

@onready var game_music_player: AudioStreamPlayer = $GameMusicPlayer
@onready var paused_game_music_player: AudioStreamPlayer = $PausedGameMusicPlayer


func _ready() -> void:
	if AudioServer.get_bus_index(MUSIC_BUS) != -1:
		game_music_player.bus = MUSIC_BUS
		paused_game_music_player.bus = MUSIC_BUS
	song_started.connect(_on_song_started)
	game_music_player.finished.connect(func(): song_finished.emit())
	paused_game_music_player.finished.connect(func(): pause_song_finished.emit())
	if get_tree().is_paused():
		music_player = paused_game_music_player
	else:
		music_player = game_music_player


# Switch the music player based on whether the game is paused or not.
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
func play(stream: AudioStream, fade: Fade = Fade.NONE, fade_time: float = DEFAULT_FADE_TIME) -> void:
	if not stream:
		return
	
	match fade:
		Fade.IN:
			fade_in(music_player, stream, fade_time)
		Fade.OUT:
			fade_out(music_player, fade_time)
			await fade_out_finished
			play(stream)
		Fade.CROSS:
			cross_fade(music_player, stream, fade_time)
		Fade.OUT_THEN_IN:
			fade_out(music_player, fade_time)
			await fade_out_finished
			fade_in(music_player, stream, fade_time)
		_: # NONE and DEFAULT
			music_player.set_stream(stream)
			music_player.play()
	
	song_started.emit()


## Stops the currently playing song. If fade_out is true, it fades out the
## currently playing song over the fade_time passed (default is 2 seconds).
func stop(fade: Fade = Fade.NONE, fade_time: float = DEFAULT_FADE_TIME) -> void:
	if !is_playing():
		return
	if fade == Fade.OUT:
		fade_out(music_player, fade_time)
		await fade_out_finished
		song_stopped.emit()
	else:
		music_player.stop()
		song_stopped.emit()


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


## Fades the [param audio_stream] in using the [param audio_stream_player]
## [AudioStreamPlayer] and the [param fade_time]. If no [param audio_stream]
## is given or [null] is passed, it is assumed that value was already set
## outside this function.
func fade_in(audio_stream_player: AudioStreamPlayer, audio_stream: AudioStream = null, fade_time: float = DEFAULT_FADE_TIME) -> void:
	if audio_stream:
		audio_stream_player.stream = audio_stream
	audio_stream_player.set_volume_db(MUTE_VOLUME_DECIBAL)
	audio_stream_player.play()
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var saved_music_bus_volume = Sound.get_bus_volume(audio_stream_player.bus)
	tween.tween_property(audio_stream_player, "volume_db", saved_music_bus_volume, fade_time)


## Fades out the currently playing stream on the [param audio_stream_player]
## [AudioStreamPlayer] using the [param fade_time]. Once the player is stopped,
## the volume is set to the default level for the passed [AudioStreamPlayer]'s
## bus.
func fade_out(audio_stream_player: AudioStreamPlayer, fade_time: float = DEFAULT_FADE_TIME) -> void:
	if !audio_stream_player.playing:
		return
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(audio_stream_player, "volume_db", MUTE_VOLUME_DECIBAL, fade_time)
	await get_tree().create_timer(fade_time).timeout
	tween.kill()
	audio_stream_player.stop()
	audio_stream_player.volume_db = Sound.get_bus_volume(audio_stream_player.bus) # Put the player's volume back to whatever is set as the max for that bus
	fade_out_finished.emit()


## Cross fades the [param audio_stream] in while fading the existing stream playing in the
## [param audio_stream_player] [AudioStreamPlayer] using the [param fade_time].
func cross_fade(audio_stream_player: AudioStreamPlayer, audio_stream: AudioStream, fade_time: float = DEFAULT_FADE_TIME) -> void:
	var temp_player := AudioStreamPlayer.new()
	add_child(temp_player)
	temp_player.bus = audio_stream_player.bus
	temp_player.set_stream(audio_stream_player.stream)
	temp_player.play(audio_stream_player.get_playback_position())
	fade_out(temp_player, fade_time)
	audio_stream_player.stop()
	fade_in(audio_stream_player, audio_stream, fade_time)
	await fade_out_finished
	temp_player.queue_free()


## Returns the title, artist and album for the currently playing song if they
## are stored in the metadata of the song and the stream is of type
## [AudioStreamOggVorbis] or [AudioStreamWAV].
## NOTE: [AudioStreamMP3] is not supported by Godot at this time.
func get_song_info_bbcode() -> String:
	var return_string: String = ""
	if music_player.stream is AudioStreamOggVorbis or music_player.stream is AudioStreamWAV:
		var tags: Dictionary = music_player.stream.get_tags()
		var title: String
		var artist: String
		var album: String
		
		if tags.has("title"):
			title = tags["title"]
		else:
			title = music_player.stream.resource_path.get_file().to_snake_case().trim_suffix(".ogg").trim_suffix(".wav").capitalize()
		
		return_string += "Song Playing: [color=lawn_green]" + title + "[/color] "
		
		if tags.has("artist"):
			artist = tags["artist"]
		elif tags.has("album_artist"):
			artist = tags["album_artist"]
		
		if artist:
			return_string += "by [color=cornflower_blue]" + artist + "[/color] "
		
		if tags.has("album"):
			album = tags["album"]
			return_string += "from [color=cornflower_blue]" + album + "[/color] "
	return return_string


## Prints to the log the details of the song currently playing when a new song
## is started. Handles situations where not all information for the song has
## been set. Only works for [AudioStreamOggVorbis] and some [AudioStreamWAV]
## files, because that's all Godot supports.
func _on_song_started() -> void:
	print_rich(get_song_info_bbcode())
		#print_rich("Song Playing: [color=lawn_green]%s[/color]" % [song.title])
		#else:
			#print_rich("Song Playing: [color=lawn_green][b]%s[/b][/color] by [color=cornflower_blue]%s[/color]" % [song.title, song.get_album_artist()])
			#var album_name = song.get_album_name()
			#if song.album.link.is_empty():
				#album_name = "[color=cornflower_blue]" + album_name + "[/color]"
			#else:
				#var url = "[url=" + song.get_album_link() +"]"
				#album_name = "[color=light_sky_blue]" + url + album_name + "[/url][/color]"
			#print_rich("Album: %s" % album_name)

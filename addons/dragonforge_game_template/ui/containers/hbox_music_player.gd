extends HBoxContainer


@export var song_list: Array[Song]


@onready var play_pause_button: Button = $PlayPauseButton
@onready var next_song_button: Button = $NextSongButton
@onready var previous_song_button: Button = $PreviousSongButton


var _current_song = 0
var song_paused = false


#func _ready() -> void:
	#Music.connect("add_song_to_music_playlist", _on_add_song_to_playlist)


func _on_play_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$PlayPauseButton.text = "Pause"
		if song_paused:
			Sound.unpause_music()
		else:
			Sound.play_music(song_list[_current_song])
	else:
		$PlayPauseButton.text = "Play"
		Sound.pause_music()
		song_paused = true


func _on_next_song_button_pressed() -> void:
	_current_song += 1
	if _current_song >= song_list.size():
		_current_song = 0
	song_paused = false
	$PlayPauseButton.set_pressed_no_signal(true)
	_on_play_pause_button_toggled(true)


func _on_previous_song_button_pressed() -> void:
	_current_song -= 1
	if _current_song < 0:
		_current_song = song_list.size() - 1
	song_paused = false
	$PlayPauseButton.set_pressed_no_signal(true)
	_on_play_pause_button_toggled(true)


func _on_add_song_to_playlist(song: Song) -> void:
	song_list.append(song)

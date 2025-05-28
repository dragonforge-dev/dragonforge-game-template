extends Label


func _ready() -> void:
	Music.now_playing.connect(_on_new_song_playing)


func _on_new_song_playing(song: Song) -> void:
	text = song.get_album_artist()

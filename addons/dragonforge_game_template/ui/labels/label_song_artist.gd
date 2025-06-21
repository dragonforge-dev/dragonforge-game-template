extends Label


func _ready() -> void:
	Music.now_playing.connect(_on_new_song_playing)


func _on_new_song_playing(song: Song) -> void:
	if song.album == null:
		text = "No Album Info"
		return
	if song.album.artist == null:
		text = "No Artist Info"
		return
	
	text = song.album.artist

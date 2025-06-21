extends RichTextLabel


func _ready() -> void:
	Music.now_playing.connect(_on_new_song_playing)
	self.connect("meta_clicked", _on_meta_clicked)


func _on_new_song_playing(song: Song) -> void:
	if song.album == null:
		text = "No Album Info"
		return
	text = "[url=%s]%s[/url]" % [song.album.link, song.album]


func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

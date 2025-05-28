extends RichTextLabel


func _ready() -> void:
	Music.now_playing.connect(_on_new_song_playing)
	self.connect("meta_clicked", _on_meta_clicked)


func _on_new_song_playing(song: Song) -> void:
	text = "[url=%s]%s[/url]" % [song.get_album_link(), song.get_album_name()]


func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

extends Button

@export var my_song: Song


func _on_pressed() -> void:
	Sound.play_music(my_song)

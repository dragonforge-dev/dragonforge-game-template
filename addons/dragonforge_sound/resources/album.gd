@icon("res://addons/dragonforge_sound/assets/icons/album.png")
class_name Album extends Resource

## The album name.
@export var name: String
## The name of the album's artist.
@export var artist: String
## A url to link to the album.
@export var link: String


## Get the name of the album. Returns "Unkown Album" if left blank.
func get_name() -> String:
	if name == null:
		return "Unknown Album"
	return name


## Get the name of the album artist. Returns "Unkown Artist" if left blank.
func get_artist() -> String:
	if artist == null:
		return "Unknown Artist"
	return artist


## Get hyperlink to the album. Returns "" if left blank.
func get_link() -> String:
	if link == null:
		return ""
	return link

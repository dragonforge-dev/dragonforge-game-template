extends RichTextLabel


func _ready() -> void:
	self.connect("meta_clicked", _on_meta_clicked)


func _on_meta_clicked(meta: Variant):
	print("click %s" % meta)
	OS.shell_open(str(meta))

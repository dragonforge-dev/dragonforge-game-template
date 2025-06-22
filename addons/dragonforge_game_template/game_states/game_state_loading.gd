class_name GameStateLoading extends State

var progress_amount := 0.0
var level_path: String

@onready var loading_screen: CanvasLayer = $"Loading Screen"
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var precentage_label: Label = %PrecentageLabel


func _activate_state() -> void:
	super()
	Game.load_level.connect(_on_load_level)
	precentage_label.text = "0 %"
	loading_screen.hide()


func _enter_state() -> void:
	super()
	Game.pause()
	loading_screen.show()
	print_rich("[color=purple][b]Level Loading[/b][/color]: %s" % [level_path])
	progress_bar.value = 0.0
	ResourceLoader.load_threaded_request(level_path)
	set_process(true)


func _exit_state() -> void:
	super()
	Game.unpause()
	loading_screen.hide()


func _process(delta: float) -> void:
	var progress: Array = []
	var status = ResourceLoader.load_threaded_get_status(level_path, progress)
	
	if progress[0] > progress_amount:
		progress_amount = progress[0]
	
	if progress_bar.value < progress_amount:
		progress_bar.value = lerp(progress_bar.value, progress_amount, delta * 60)
	progress_bar.value += delta * 0.2 * (3.0 if progress_amount >= 1.0 else clamp(0.95 - progress_bar.value, 0.0, 1.0))
	
	precentage_label.text = str(int(progress_bar.value * 100.0)) + " %"
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		progress_bar.value = 1.0
		precentage_label.text = "100 %"


func _on_load_level(level_name: String, _player: Node, _target: String) -> void:
	if level_name.contains("uid://"):
		level_path = level_name
	else:
		level_path = "res://levels/" + level_name + ".tscn"
	switch_state()

class_name GameStateSplashScreen extends State

const SPLASH_SCREENS_VIEWED = "splash_screens_viewed"

## All the splash screens to show, and the order to show them in.
@export var active_splash_screens: Array[SplashScreen]
## If true, you can skip the splash screens as long as you have viewed them once.
## (Resets if settings.conf is deleted in the UserData folder.)
@export var splash_screens_are_skippable = true

var _current_splash_screen: int = 0
var splash_screens_viewed := false


func _ready() -> void:
	for splash_screen in active_splash_screens:
		splash_screen.splash_complete.connect(_on_splash_complete)
	# Load whether or not the splash screens have been viewed.
	var splash_viewed = Disk.load_setting(SPLASH_SCREENS_VIEWED)
	if splash_viewed is bool:
		splash_screens_viewed = splash_viewed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip") and splash_screens_are_skippable and splash_screens_viewed:
		Game.splash_screens_complete.emit()


func _enter_state() -> void:
	super()
	set_process_input(true)
	if active_splash_screens.size() == 0:
		Game.splash_screens_complete.emit()
		return
	active_splash_screens[_current_splash_screen].show()


func _exit_state() -> void:
	super()
	set_process_input(false)
	can_transition = false # Makes this one shot. Can't call it again.
	queue_free() # Delete these from memory once they've served their purpose.


func _on_splash_complete() -> void:
	active_splash_screens[_current_splash_screen].hide()
	_current_splash_screen += 1
	if _current_splash_screen < active_splash_screens.size():
		active_splash_screens[_current_splash_screen].show()
	else:
		print("Splash Complete")
		splash_screens_viewed = true
		Disk.save_setting(splash_screens_viewed, SPLASH_SCREENS_VIEWED)
		Game.splash_screens_complete.emit()

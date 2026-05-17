## Shows all the [SplashScreen] nodes attached as children, in the order they
## are attached. Add any [SplashScreen] nodes you want shown at the beginning
##  of the game. If this [State] has no child [SplashScreen] nodes, the splash
## screen state will be skipped.
class_name SplashScreenGameState extends State

const SPLASH_SCREENS_VIEWED = "splash_screens_viewed"

## If true, you can skip the splash screens using the "skip" action (which is
## automatically added when this plugin is activated) as long as you have viewed
## them once. See [member GameStateSplashScreen.splash_screens_viewed] for more
## information.
## See also: [member Main.bypass_splash_screens_during_debug].
@export var splash_screens_are_skippable: bool = true

var _current_splash_screen: int = 0
## Stores whether the user has seen the splash screens before. Saved to disk.
## Once this value is true, and as long as splash_screens_are_skippable remains
## true, the player may skip splash screens using the "skip" action (which is
## automatically added when this plugin is activated). This value resets to
## false if configuration.settings is deleted in the UserData folder.
## See also: [member Main.bypass_splash_screens_during_debug].
var splash_screens_viewed: bool = false
## All the splash screens to show, and the order to show them in. Populated
## using the child nodes of this [State].
var _active_splash_screens: Array[SplashScreen]


func _ready() -> void:
	super()
	for splash_screen in get_children():
		if splash_screen is SplashScreen:
			splash_screen.splash_complete.connect(_on_splash_complete)
			_active_splash_screens.append(splash_screen)
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
	if _active_splash_screens.size() == 0:
		Game.splash_screens_complete.emit()
		return
	_active_splash_screens[_current_splash_screen].show()


func _exit_state() -> void:
	super()
	set_process_input(false)
	can_transition = false # Makes this one shot. Can't call it again.
	queue_free() # Delete these from memory once they've served their purpose.


func _on_splash_complete() -> void:
	_active_splash_screens[_current_splash_screen].hide()
	_current_splash_screen += 1
	if _current_splash_screen < _active_splash_screens.size():
		_active_splash_screens[_current_splash_screen].show()
	else:
		print("Splash Complete")
		splash_screens_viewed = true
		Disk.save_setting(splash_screens_viewed, SPLASH_SCREENS_VIEWED)
		Game.splash_screens_complete.emit()

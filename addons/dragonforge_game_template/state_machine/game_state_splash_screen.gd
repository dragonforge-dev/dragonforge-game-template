class_name GameStateSplashScreen extends State

@onready var splash_screens: Node = %SplashScreens


func enter_state() -> void:
	super()
	splash_screens.start()


func exit_state() -> void:
	super()
	can_transition = false # Makes this one shot. Can't call it again.
	splash_screens.queue_free() # Delete these from memory once they've served their purpose.

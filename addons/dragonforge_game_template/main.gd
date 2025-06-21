class_name Main extends Node

@export var bypass_splash_screens: bool = false

@onready var game_state_machine: GameStateMachine = $"Game State Machine"
@onready var splash_screen: State = %"Splash Screen"
@onready var main_menu: State = %"Main Menu"
@onready var loading_screen: State = %"Loading Screen"
@onready var gameplay: State = %Gameplay
@onready var minigame: State = %Minigame
@onready var cutscene: State = %Cutscene
@onready var dialogue: State = %Dialogue
@onready var splash_screens: Node = %SplashScreens


func _ready() -> void:
	splash_screens.complete.connect(_on_splash_screens_complete)
	if (bypass_splash_screens and OS.is_debug_build()) :
		game_state_machine.switch_state(main_menu)
	else:
		game_state_machine.switch_state(splash_screen)


func _on_splash_screens_complete() -> void:
	game_state_machine.switch_state(main_menu)

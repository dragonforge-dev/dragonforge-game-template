@icon("res://addons/dragonforge_game_template/assets/textures/icons/state_icon_64x64_white.png")
class_name State extends Node
# A abstract virtual state for states to implement.

## Set to false if this staet cannot be transitioned to.
## For example when waiting for a cooldown timer to expire.
var can_transition = true


## Called when the state is added to a state machine.
func activate_state() -> void:
	print_rich("[color=forest_green][b]Activate[/b][/color] [color=ivory]%s State:[/color] %s" % [get_parent().name, self.name])


## Called when a state is removed from a state machine.
func deactivate_state() -> void:
	print_rich("[color=#d42c2a][b]Deactivate[/b][/color] [color=ivory]%s State:[/color] %s" % [get_parent().name, self.name])


## Called every time the state is entered.
func enter_state() -> void:
	print_rich("[color=deep_sky_blue][b]Enter[/b][/color] [color=ivory]%s State:[/color] %s" % [get_parent().name, self.name])


## Called every time the state is exited.
func exit_state() -> void:
	print_rich("[color=dark_orange][b]Exit[/b][/color] [color=ivory]%s State:[/color] %s" % [get_parent().name, self.name])

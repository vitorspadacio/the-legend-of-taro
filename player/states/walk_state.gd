@icon("res://assets/icons/state.svg")
class_name PlayerWalkState extends PlayerState

func init() -> void:
	state_name = "walk"
	
func enter() -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity = player.direction * player.move_speed
	return null
	
func process(_delta: float) -> PlayerState:
	return get_command_state()

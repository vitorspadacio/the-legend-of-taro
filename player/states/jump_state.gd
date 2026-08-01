@icon("res://assets/icons/state.svg")
class_name PlayerJumpState extends PlayerState

func init() -> void:
	state_name = "jump"
	
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
	if player.direction.x == 0 && player.direction.y == 0:
		return idle
	return null

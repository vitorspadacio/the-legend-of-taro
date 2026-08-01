@icon("res://assets/icons/state.svg")
class_name PlayerSwingState extends PlayerState

@export var slow_rate := 0.5

func init() -> void:
	state_name = "swing"
	
func enter() -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("swing_test"):
		return idle
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity = player.direction * player.move_speed * slow_rate
	return null
	
func process(_delta: float) -> PlayerState:
	return null

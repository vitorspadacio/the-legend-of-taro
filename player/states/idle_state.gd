@icon("res://assets/icons/state.svg")
class_name PlayerIdleState extends PlayerState

var decelerate_rate: float = 15

func init() -> void:
	state_name = "idle"
	
func enter() -> void:
	player.velocity.x = 0
	player.velocity.y = 0
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(delta: float) -> PlayerState:
	var deceleration_x: float = player.velocity.x * decelerate_rate * delta
	player.velocity.x -= deceleration_x
	return null
	
func process(_delta: float) -> PlayerState:
	return get_command_state()

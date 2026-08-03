@icon("res://assets/icons/state.svg")
class_name PlayerIdleState extends PlayerState

var decelerate_rate: float = 15

func init() -> void:
	pass
	
func enter() -> void:
	player.animation.play("idle")
	player.velocity.x = 0
	player.velocity.y = 0
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null
	
func process(_delta: float) -> PlayerState:
	return get_command_state()

@icon("res://assets/icons/state.svg")
class_name PlayerWalkState extends PlayerState

func init() -> void:
	pass
	
func enter() -> void:
	player.animation.play("walk")
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(delta: float) -> PlayerState:
	player.movement.move(delta)
	return null
	
func process(_delta: float) -> PlayerState:
	return get_command_state()

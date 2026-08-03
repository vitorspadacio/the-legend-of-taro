@icon("res://assets/icons/state.svg")
class_name PlayerSwingState extends PlayerState

@export var slow_rate := 0.5

func init() -> void:
	pass
	
func enter() -> void:
	player.animation.play("swing")
	pass
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.movement.move(slow_rate)
	return null
	
func process(_delta: float) -> PlayerState:
	return null

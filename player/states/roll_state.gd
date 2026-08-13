@icon("res://assets/icons/state.svg")
class_name PlayerRollState extends PlayerState

@export var durantion := 0.5
@export var speed_rate := 1.25

var timer := 0.0

func init() -> void:
	pass
	
func enter() -> void:
	player.animation.play("roll")
	timer = durantion
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.movement.roll(speed_rate)
	return null
	
func process(delta: float) -> PlayerState:
	timer -= delta
	if timer <= 0:
		if player.movement.direction != Vector2.ZERO:
			return walk
		else:
			return idle

	return null

@icon("res://assets/icons/state.svg")
class_name PlayerRollState extends PlayerState

@export var add_speed := 1.25
@export var durantion := 0.5
var timer := 0.0

func init() -> void:
	state_name = "roll"
	
func enter() -> void:
	timer = durantion
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity = player.facing_direction * player.move_speed * add_speed
	return null
	
func process(delta: float) -> PlayerState:
	timer -= delta
	if timer <= 0:
		if player.direction != Vector2.ZERO:
			return walk
		else:
			return idle
	return null

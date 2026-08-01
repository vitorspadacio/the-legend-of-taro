@icon("res://assets/icons/state.svg")
class_name PlayerWalkState extends PlayerState

func init() -> void:
	state_name = "walk"
	
func enter() -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if player.controller.idle:
		return idle
	if player.controller.walk:
		return walk
	if player.controller.roll:
		return roll
	if player.controller.attack:
		return attack
	if player.controller.swing:
		return swing
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity = player.direction * player.move_speed
	return null
	
func process(_delta: float) -> PlayerState:
	if player.direction.x == 0 && player.direction.y == 0:
		return idle
	return null

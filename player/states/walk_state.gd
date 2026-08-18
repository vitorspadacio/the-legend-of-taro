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
	player.update_direction()
	player.movement.move(1.0, delta)
	return null
	
func process(_delta: float) -> PlayerState:
	if player.input.attack:
		return attack
	if player.input.roll:
		return roll
	if player.input.jump:
		return jump
	if player.input.swing:
		return swing
	if player.input.direction == Vector2.ZERO:
		return idle

	return null

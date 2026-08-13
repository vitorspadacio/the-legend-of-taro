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
	player.update_direction()
	return null
	
func process(_delta: float) -> PlayerState:
	if player.input.attack:
		return attack
	if player.input.roll:
		return roll
	if player.input.swing:
		return swing
	if player.input.direction != Vector2.ZERO:
		return walk

	return null

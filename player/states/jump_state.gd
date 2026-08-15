@icon("res://assets/icons/state.svg")
class_name PlayerJumpState extends PlayerState

func enter() -> void:
	player.jump.jump()
	player.animation.play("jump")
	player.collision.disabled = true
	
func exit() -> void:
	player.collision.disabled = false

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(delta: float) -> PlayerState:
	if player.jump.can_jump():
		player.update_direction()
		player.movement.move(delta)
	if not player.jump.is_jumping:
		return idle
	return null
	
func process(_delta: float) -> PlayerState:
	if player.input.direction.x == 0 && player.input.direction.y == 0:
		return idle
	return null

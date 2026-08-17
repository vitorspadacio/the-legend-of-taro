@icon("res://assets/icons/state.svg")
class_name PlayerJumpState extends PlayerState

func enter() -> void:
	player.jump.jump()
	player.animation.play("jump")
	player.animation.animation_player.pause()
	player.collision.disabled = true
	player.damage_area.monitorable = false
	
func exit() -> void:
	player.collision.disabled = false
	player.damage_area.monitorable = true

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(delta: float) -> PlayerState:
	if player.jump.can_jump():
		player.update_direction()
		player.movement.move(delta)
		set_jump_frame()
	if not player.jump.is_jumping:
		return idle
	return null

func set_jump_frame() -> void:
	var progress := player.jump.jump_time / player.jump.jump_duration
	player.animation.animation_player.seek(
		progress * 0.3,
		true
	)
	
func process(_delta: float) -> PlayerState:
	if player.input.direction.x == 0 && player.input.direction.y == 0:
		return idle
	return null

@icon("res://assets/icons/state.svg")
class_name BossJumpState extends EnemyJumpState

var target: Vector2
var random_direction: Vector2

func enter() -> void:
	target = enemy.blackboard.target.global_position
	random_direction = Vector2.from_angle(randf() * TAU)

	enemy.jump.jump()
	enemy.animation.play_no_direction("jump")
	enemy.animation.animation_player.pause()
	enemy.collision.disabled = true
	enemy.hazard_area.monitorable = false
	enemy.damage_area.monitorable = false
	enemy.blackboard.can_decide = false
	on_cooldown = true
	timer = 0

func exit() -> void:
	target = Vector2.ZERO
	enemy.hazard_area.monitorable = true
	enemy.damage_area.monitorable = true

func physics_process(delta: float) -> EnemyState:
	if enemy.jump.can_jump():
		get_target_position()
		enemy.movement.roll(5.0)
		set_jump_frame()
	elif not enemy.jump.is_jumping:
		enemy.blackboard.can_decide = true

	timer += delta
	if timer >= duration:
		enemy.blackboard.can_decide = true
	return null

func get_target_position() -> void:
	var jump_target := target + random_direction * 24.0

	enemy.movement.update_direction(
		enemy.global_position.direction_to(jump_target)
	)
	
func set_jump_frame() -> void:
	# var height_progress := enemy.jump.height / enemy.jump.jump_height
	# height_progress = clampf(height_progress, 0.0, 1.0)
	# var animation_position := height_progress * 1.3
	# enemy.animation.animation_player.seek(animation_position, true)
	var progress := enemy.jump.jump_time / enemy.jump.jump_duration
	enemy.animation.animation_player.seek(
		progress, true)

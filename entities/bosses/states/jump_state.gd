@icon("res://assets/icons/state.svg")
class_name BossJumpState extends EnemyJumpState

@export var prepare_duration := 0.2
@export var jump_end_time := 1.0
@export var sound: AudioStream

var target: Vector2
var jump_started := false
var previous_jump_duration := 0.0

func enter() -> void:
	print(target)
	jump_started = false
	previous_jump_duration = enemy.jump.jump_duration
	enemy.animation.play_no_direction("jump")
	enemy.animation.animation_player.pause()
	enemy.hazard_area.monitorable = false
	enemy.damage_area.monitorable = false
	enemy.blackboard.can_decide = false
	on_cooldown = true
	timer = 0

func exit() -> void:
	target = Vector2.ZERO
	enemy.jump.jump_duration = previous_jump_duration
	enemy.hazard_area.monitorable = true
	enemy.damage_area.monitorable = true

func physics_process(delta: float) -> EnemyState:
	timer += delta
	set_jump_frame()

	if timer < prepare_duration:
		enemy.velocity = Vector2.ZERO
	elif timer < jump_end_time:
		_start_jump()

		print(enemy.jump.can_jump())
		if enemy.jump.can_jump():
			get_target_position()
			enemy.movement.move(3.0, delta)
	else:
		enemy.velocity = Vector2.ZERO

	if timer >= duration:
		enemy.blackboard.can_decide = true

	return null

func _start_jump() -> void:
	if jump_started:
		return

	Audio.play_spatial_sound(sound, enemy.global_position)
	enemy.jump.jump_duration = jump_end_time - prepare_duration
	enemy.jump.jump()
	jump_started = true

func get_target_position() -> void:
	enemy.movement.update_direction(
		enemy.global_position.direction_to(target)
	)
	
func set_jump_frame() -> void:
	enemy.animation.animation_player.seek(
		minf(timer, duration), true)

@icon("res://assets/icons/state.svg")
class_name EnemyJumpState extends EnemyState

@export var attack_range := 20
@export var cooldown := 3.0
@export var duration := 1.0

var timer := 0.0
var on_cooldown := false

func enter() -> void:
	enemy.jump.jump()
	enemy.animation.play("walk")
	enemy.animation.animation_player.pause()
	enemy.collision.disabled = true
	enemy.damage_area.monitorable = false
	enemy.blackboard.can_decide = false
	on_cooldown = true
	timer = 0
	
func exit() -> void:
	run_cooldown()
	enemy.collision.disabled = false
	enemy.damage_area.monitorable = true

func physics_process(delta: float) -> EnemyState:
	if enemy.jump.can_jump():
		enemy.navigation.target_position = enemy.blackboard.target.global_position
		var next_point = enemy.navigation.get_next_path_position()
		enemy.movement.update_direction(enemy.global_position.direction_to(next_point))
		enemy.movement.roll(3.0)
		set_jump_frame()
	elif not enemy.jump.is_jumping:
		enemy.blackboard.can_decide = true

	timer += delta
	if timer >= duration:
		enemy.blackboard.can_decide = true
	return null

func set_jump_frame() -> void:
	var progress := enemy.jump.jump_time / enemy.jump.jump_duration
	enemy.animation.animation_player.seek(
		progress * 0.4,
		true
	)

func run_cooldown() -> void:
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false

func can_attack() -> bool:
	if enemy.blackboard.distance_to_target <= attack_range and not on_cooldown:
		return true
	return false

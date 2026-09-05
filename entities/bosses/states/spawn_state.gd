@icon("res://assets/icons/state.svg")
class_name BossSpawnState extends EnemyState

const SLIME_SCENE := preload("res://entities/enemies/slime/slime.tscn")

@export var windup_duration := 1.0
@export var slime_count := 3
@export var launch_distance_min := 42.0
@export var launch_distance_max := 64.0
@export var launch_duration := 0.35

var timer := 0.0
var slimes_spawned := false
var hurt_duration := 0.0
var slimes_remaining := 0

func enter() -> void:
	timer = 0.0
	slimes_spawned = false
	hurt_duration = 0.0
	enemy.velocity = Vector2.ZERO
	enemy.movement.update_direction(Vector2.ZERO)
	enemy.animation.play_no_direction("idle")
	enemy.blackboard.can_decide = false

func physics_process(delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	timer += delta

	if not slimes_spawned and timer >= windup_duration:
		_spawn_slimes()
		slimes_spawned = true
		timer = 0.0
		enemy.animation.play_no_direction("hurt")
		hurt_duration = enemy.animation.animation_player.current_animation_length

	if slimes_spawned and timer >= hurt_duration:
		enemy.blackboard.can_decide = true

	return null

func _spawn_slimes() -> void:
	slimes_remaining = slime_count
	for _index in slime_count:
		var slime := SLIME_SCENE.instantiate() as Enemy
		slime.health.died.connect(_on_slime_dies)
		var direction := Vector2.from_angle(randf() * TAU)
		var launch_distance := randf_range(
			launch_distance_min, launch_distance_max
		)

		get_tree().current_scene.add_child(slime)
		var player = get_tree().get_first_node_in_group("player")
		slime.blackboard.target = player
		slime.global_position = enemy.global_position
		slime.jump.jump()
		_launch_slime(slime, direction, launch_distance / launch_duration)

func _on_slime_dies() -> void:
	slimes_remaining -= 1

func can_spawn_again() -> bool:
	if slimes_remaining <= 0:
		return true
	else:
		return false

func _launch_slime(slime: Enemy, direction: Vector2, speed: float) -> void:
	var elapsed := 0.0
	slime.set_physics_process(false)

	while elapsed < launch_duration and is_instance_valid(slime):
		slime.velocity = direction * speed
		slime.move_and_slide()

		if slime.is_on_wall():
			break

		await get_tree().physics_frame
		elapsed += get_physics_process_delta_time()

	if is_instance_valid(slime):
		slime.velocity = Vector2.ZERO
		slime.set_physics_process(true)

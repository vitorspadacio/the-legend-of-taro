@icon("res://assets/icons/state.svg")
class_name EnemyAttackState extends EnemyState

@export var attack_range := 20
@export var cooldown := 3.0
@export var duration := 1.0
@export var sound: AudioStream

var timer := 0.0
var on_cooldown := false

func enter() -> void:
	Audio.play_spatial_sound(sound, enemy.global_position)
	enemy.animation.play("idle")
	set_attack_direction(enemy.movement.direction)
	VisualEffects.create_claw(enemy.global_position, enemy.movement.direction)
	enemy.attack_area.activate()
	enemy.blackboard.can_decide = false
	enemy.damage_area.make_invulnerable()
	on_cooldown = true
	timer = 0

func exit() -> void:
	run_cooldown()
	enemy.blackboard.can_decide = true
	pass

func physics_process(delta: float) -> EnemyState:
	timer += delta
	if timer >= duration:
		enemy.blackboard.can_decide = true
	return null

func can_attack() -> bool:
	if enemy.blackboard.distance_to_target <= attack_range and not on_cooldown:
		return true
	return false

func run_cooldown() -> void:
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false

func set_attack_direction(direction: Vector2) -> void:
	enemy.attack_area.rotation = Vector2.DOWN.angle_to(direction.normalized())

@icon("res://assets/icons/state.svg")
class_name EnemyHurtState extends EnemyState

@export var force := 30.0
@export var invulnerable_duration := 0.2
@export var sound_effect: AudioStream

var direction := Vector2.ZERO
var time: float = 0.0

func init() -> void:
	enemy.damage_taken.connect(_on_hurt)
	
func enter() -> void:
	enemy.animation.play("idle")
	time = enemy.animation.animation_player.current_animation_length + 0.15
	enemy.damage_area.make_invulnerable(invulnerable_duration)
	enemy.blackboard.can_decide = false
	enemy.blackboard.target = enemy.blackboard.damage_source.owner
	enemy.blackboard.damage_source = null
	
func exit() -> void:
	pass

func physics_process(delta: float) -> PlayerState:
	enemy.movement.knockback(force, direction, delta)
	return null
	
func process(delta: float) -> PlayerState:
	time -= delta
	if time <= 0:
		enemy.blackboard.can_decide = true
	return null

func flash_red() -> void:
	var tween := create_tween()
	for i in 3:
		tween.tween_property(enemy, "modulate", Color.RED, 0.06)
		tween.tween_property(enemy, "modulate", Color.WHITE, 0.06)

func _on_hurt(attack_area: AttackArea) -> void:
	flash_red()
	enemy.blackboard.damage_source = attack_area
	direction = (enemy.global_position - attack_area.global_position).normalized()

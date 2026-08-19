@icon("res://assets/icons/state.svg")
class_name BossHurtState extends EnemyHurtState

func init() -> void:
	enemy.damage_taken.connect(_on_hurt)

func enter() -> void:
	Audio.play_spatial_sound(sound, enemy.global_position)
	enemy.animation.play_no_direction("hurt")
	time = enemy.animation.animation_player.current_animation_length + 0.15
	enemy.damage_area.make_invulnerable(time + invulnerable_duration)
	enemy.blackboard.can_decide = false
	enemy.blackboard.target = enemy.blackboard.damage_source.owner
	enemy.blackboard.damage_source = null

func physics_process(_delta: float) -> PlayerState:
	return null

func _on_hurt(attack_area: AttackArea) -> void:
	enemy.blackboard.damage_source = attack_area
	direction = (enemy.global_position - attack_area.global_position).normalized()

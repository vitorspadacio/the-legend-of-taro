@icon("res://assets/icons/state.svg")
class_name BossDeathState extends EnemyState

func enter() -> void:
	enemy.animation.play_no_direction("death")
	await enemy.animation.animation_player.animation_finished
	VisualEffects.create_smoke(enemy.global_position)
	enemy.blackboard.damage_source = null
	enemy.blackboard.can_decide = false
	enemy.queue_free()

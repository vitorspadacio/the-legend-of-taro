@icon("res://assets/icons/state.svg")
class_name BossIdleState extends EnemyIdleState

func enter() -> void:
	enemy.animation.play_no_direction("idle")
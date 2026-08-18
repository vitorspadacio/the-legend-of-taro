@icon("res://assets/icons/state.svg")
class_name BossWalkState extends EnemyState

func init() -> void:
	pass
	
func enter() -> void:
	enemy.animation.play_no_direction("idle")

func exit() -> void:
	pass

func physics_process(_delta: float) -> EnemyState:
	enemy.movement.move()
	return null

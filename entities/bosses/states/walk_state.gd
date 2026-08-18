@icon("res://assets/icons/state.svg")
class_name BossWalkState extends EnemyState

func init() -> void:
	pass
	
func enter() -> void:
	enemy.animation.play_no_direction("idle")

func exit() -> void:
	pass

func physics_process(_delta: float) -> EnemyState:
	if enemy.blackboard.target:
		enemy.navigation.target_position = enemy.blackboard.target.global_position
		var next_point = enemy.navigation.get_next_path_position()
		enemy.movement.update_direction(enemy.global_position.direction_to(next_point))
	enemy.movement.move()
	return null

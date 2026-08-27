@icon("res://assets/icons/state.svg")
class_name EnemyWalkState extends EnemyState

func enter() -> void:
	wander()
	var next_position := enemy.navigation.get_next_path_position()
	var direction := enemy.global_position.direction_to(next_position)

	enemy.movement.update_direction(direction)
	enemy.animation.play("walk")


func physics_process(_delta: float) -> EnemyState:
	enemy.animation.direction_name = enemy.movement.direction_name
	enemy.animation.play()
	enemy.movement.move()
	return null


func wander() -> void:
	var target := NavigationServer2D.map_get_random_point(
		enemy.navigation.get_navigation_map(),
		enemy.navigation.navigation_layers,
		false
	)

	enemy.navigation.target_position = target

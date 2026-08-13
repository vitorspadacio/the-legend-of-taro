@icon("res://assets/icons/state.svg")
class_name EnemyChaseState extends EnemyState

@export var chase_speed := 100.0
@export var cooldown := 15.0

var timer := 0.0

func init() -> void:
	pass
	
func enter() -> void:
	enemy.animation.play("walk")
	enemy.blackboard.can_decide = false
	timer = cooldown
	
func exit() -> void:
	pass

func physics_process(delta: float) -> EnemyState:
	if not enemy.blackboard.target or timer <= 0:
		enemy.blackboard.can_decide = true
		return null

	timer -= delta

	enemy.navigation.target_position = enemy.blackboard.target.global_position
	var next_point = enemy.navigation.get_next_path_position()
	enemy.movement.update_direction(enemy.global_position.direction_to(next_point))
	enemy.animation.direction_name = enemy.movement.direction_name
	enemy.animation.play()
	enemy.movement.move()
	return null

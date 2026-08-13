@icon("res://assets/icons/state.svg")
class_name EnemyWalkState extends EnemyState

func init() -> void:
	pass
	
func enter() -> void:
	enemy.movement.update_direction(Vector2.RIGHT.rotated(randf() * TAU))
	enemy.animation.play("walk")

func exit() -> void:
	pass

func physics_process(_delta: float) -> EnemyState:
	enemy.animation.direction_name = enemy.movement.direction_name
	enemy.animation.play()
	enemy.movement.move()
	return null

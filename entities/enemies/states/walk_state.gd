@icon("res://assets/icons/state.svg")
class_name EnemyWalkState extends EnemyState

@export var cooldown := 1.0

var timer := 0.0

func init() -> void:
	pass
	
func enter() -> void:
	enemy.movement.direction = Vector2.RIGHT.rotated(randf() * TAU)
	enemy.animation.play("idle")
	timer = cooldown
	
func exit() -> void:
	pass

func physics_process(delta: float) -> EnemyState:
	timer -= delta
	enemy.animation.direction_name = enemy.movement.direction_name
	enemy.animation.play()
	enemy.movement.move()

	if timer <= 0:
		return idle
	return null

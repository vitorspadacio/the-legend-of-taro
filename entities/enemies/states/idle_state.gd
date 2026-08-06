@icon("res://assets/icons/state.svg")
class_name EnemyIdleState extends EnemyState

@export var cooldown := 1.0

func init() -> void:
	pass
	
func enter() -> void:
	enemy.animation.play("idle")
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> State:
	return null

func process(_delta: float) -> State:
	return null
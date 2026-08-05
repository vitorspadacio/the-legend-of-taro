@icon("res://assets/icons/state.svg")
class_name EnemyIdleState extends EnemyState

@export var cooldown := 1.0

var timer := 0.0

func init() -> void:
	pass
	
func enter() -> void:
	enemy.animation.play("idle")
	timer = cooldown
	
func exit() -> void:
	pass

func physics_process(delta: float) -> State:
	timer -= delta
	return null

func process(_delta: float) -> State:
	if timer <= 0:
		return walk
	return null
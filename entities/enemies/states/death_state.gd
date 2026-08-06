@icon("res://assets/icons/state.svg")
class_name EnemyDeathState extends EnemyState

func enter() -> void:
	print("morreu")
	enemy.blackboard.damage_source = null
	enemy.blackboard.can_decide = false
	enemy.queue_free()

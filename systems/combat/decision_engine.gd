@icon("res://general/icons/decision_engine.svg")
class_name DecisionEngine extends Node

var blackboard: Blackboard
var current_state: EnemyState
var enemy: Enemy

func _ready() -> void:
	while not enemy:
		await get_tree().process_frame

func decide() -> EnemyState:
	return null
@icon("res://assets/icons/state.svg")
class_name EnemyState extends State

@onready var idle: EnemyState = %Idle
@onready var walk: EnemyState = %Walk

var enemy: Enemy

func re_enter() -> bool:
	return true

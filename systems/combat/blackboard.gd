class_name Blackboard extends Resource

var can_decide: bool = true
var damage_source: AttackArea = null
var direction: float = 1.0
var distance_to_target: float = -1
var health := 0.0
var target: Player = null

func update_distance_to_target(position: Vector2) -> void:
	if target:
		distance_to_target = position.distance_to(target.global_position)
	else:
		distance_to_target = -1

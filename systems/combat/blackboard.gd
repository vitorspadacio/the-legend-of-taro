class_name Blackboard extends Resource

enum BossPhase {Phase1, Phase2, Phase3}

var can_decide: bool = true
var damage_source: AttackArea = null
var direction: float = 1.0
var distance_to_target: float = -1
var target: Node2D = null

var boss_phase: BossPhase
var last_attack: String

func update_distance_to_target(position: Vector2) -> void:
	if target:
		distance_to_target = position.distance_to(target.global_position)
	else:
		distance_to_target = -1

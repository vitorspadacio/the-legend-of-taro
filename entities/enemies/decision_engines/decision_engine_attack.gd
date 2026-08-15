class_name DecisionEngineAttack
extends DecisionEngine

@export var entity: Enemy

@export var attack: EnemyState
@export var chase: EnemyChaseState
@export var death: EnemyDeathState
@export var hurt: EnemyHurtState
@export var idle: EnemyIdleState
@export var walk: EnemyWalkState

var cooldown := 1.0

var idle_timer := 0.0
var walk_timer := 0.0

enum PatrolState {
	IDLE,
	WALK
}

var patrol_state := PatrolState.IDLE
var patrol_timer := 1.0

@export var idle_time := 2.0
@export var walk_time := 1.5

func _ready() -> void:
	await super()

func _process(delta: float) -> void:
	patrol_timer -= delta

	if patrol_timer <= 0:
		match patrol_state:
			PatrolState.IDLE:
				patrol_state = PatrolState.WALK
				patrol_timer = walk_time

			PatrolState.WALK:
				patrol_state = PatrolState.IDLE
				patrol_timer = idle_time

func decide() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= 0:
			return death
		else:
			return hurt

	if not blackboard.can_decide:
		return null
	
	if blackboard.target:
		if attack.can_attack():
			return attack
		return chase

	match patrol_state:
		PatrolState.IDLE:
			return idle

		PatrolState.WALK:
			return walk

	return idle

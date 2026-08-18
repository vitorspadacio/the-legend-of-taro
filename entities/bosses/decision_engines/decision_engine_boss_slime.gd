class_name DecisionEngineBossSlime
extends DecisionEngine

@export var entity: Enemy

@export var death: BossDeathState
@export var hurt: BossHurtState
@export var idle: BossIdleState
@export var jump: BossJumpState
@export var walk: EnemyState

var cooldown := 5.0
var timer := 0.0

func _ready() -> void:
	await super()

func _process(delta: float) -> void:
	timer -= delta

func decide() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= 0:
			return death
		else:
			return hurt

	if not blackboard.can_decide:
		return null

	if timer <= 0 and blackboard.target:
		timer = randf_range(3 - cooldown, cooldown)
		return jump
	# if not blackboard.can_decide:
	# 	return null
	# if not entity.jump.is_jumping:
	# 	blackboard.target = null
		# if attack.can_attack():
	# 		return attack
	# 	return chase
	# match patrol_state:
	# 	PatrolState.IDLE:
	# 		return idle
	# 	PatrolState.WALK:
	# 		return walk
	return idle

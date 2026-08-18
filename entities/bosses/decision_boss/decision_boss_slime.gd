class_name DecisionBossSlime
extends DecisionEngine

@export var entity: Enemy

@export var death: BossDeathState
@export var hurt: BossHurtState
@export var idle: BossIdleState
@export var jump: BossJumpState
@export var spawn: EnemyState
@export var walk: EnemyState

var player: Player

var jump_cooldown := 5.0
var jump_timer := 0.0

var spawn_cooldown := 20.0
var spawn_timer := 0.0

@onready var marker_center: Marker2D = get_parent().get_node("%MarkerCenter")
@onready var marker_up: Marker2D = get_parent().get_node("%MarkerUp")
@onready var marker_down: Marker2D = get_parent().get_node("%MarkerDown")

func _ready() -> void:
	await super()
	player = get_tree().get_first_node_in_group("player")
	blackboard.boss_phase = blackboard.BossPhase.Phase1
	blackboard.target = player

func _process(delta: float) -> void:
	jump_timer -= delta
	spawn_timer -= delta

func decide() -> EnemyState:
	if blackboard.boss_phase == blackboard.BossPhase.Phase1:
		return phase_1()
	else:
		return phase_2()

func phase_1() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= 6:
			print("entrou fase 2")
			blackboard.boss_phase = blackboard.BossPhase.Phase2
			jump.target = marker_center.global_position
			blackboard.damage_source = null
			return jump
		return hurt

	if not blackboard.can_decide:
		return null
	
	if jump_timer <= 0 and blackboard.target:
		jump_timer = randf_range(3 - jump_cooldown, jump_cooldown)
		blackboard.last_attack = "jump"
		var markers: Array[Marker2D] = [
			marker_center,
			marker_up,
			marker_down
		]
		jump.target = markers.pick_random().global_position
		return jump

	return idle

func phase_2() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= 0:
			return death
		return hurt

	if not blackboard.can_decide:
		return null
	
	if spawn_timer <= 0 and blackboard.target:
		blackboard.last_attack = "spawn"
		spawn_timer = spawn_cooldown
		return spawn

	if jump_timer <= 0 and blackboard.target:
		jump_timer = randf_range(3 - jump_cooldown, jump_cooldown)
		blackboard.last_attack = "jump"
		player = get_tree().get_first_node_in_group("player")
		print(player)
		jump.target = player.global_position
		return jump

	return walk

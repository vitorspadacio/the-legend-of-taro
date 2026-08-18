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
var phase_transition := StateSequence.new()

var jump_cooldown := 5.0
var jump_timer := 0.0

var spawn_cooldown := 20.0
var spawn_timer := 0.0

@onready var marker_center: Marker2D = get_parent().get_node("%MarkerCenter")
@onready var marker_up: Marker2D = get_parent().get_node("%MarkerUp")
@onready var marker_down: Marker2D = get_parent().get_node("%MarkerDown")
@onready var marker_left: Marker2D = get_parent().get_node("%MarkerLeft")
@onready var marker_right: Marker2D = get_parent().get_node("%MarkerRight")

func _ready() -> void:
	await super()
	blackboard.boss_phase = blackboard.BossPhase.Phase1

func _process(delta: float) -> void:
	jump_timer -= delta
	spawn_timer -= delta
	phase_transition.process(delta)

func decide() -> EnemyState:
	player = get_tree().get_first_node_in_group("player")
	blackboard.target = player

	if phase_transition.is_running():
		return _advance_phase_transition()

	if blackboard.boss_phase == blackboard.BossPhase.Phase1:
		return phase_1()
	else:
		return phase_2()

func phase_1() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= entity.health.max_health * 0.5:
			_start_phase_transition()
			return _advance_phase_transition()
		return hurt

	if not blackboard.can_decide:
		return null
	
	if jump_timer <= 0 and blackboard.target:
		jump_timer = randf_range(3 - jump_cooldown, jump_cooldown)
		blackboard.last_attack = "jump"
		if randf() < 0.5:
			jump.target = blackboard.target.global_position
		else:
			var markers: Array[Marker2D] = [
				marker_center,
				marker_up,
				marker_down,
				marker_left,
				marker_right
			]
			jump.target = markers.pick_random().global_position
		return jump

	return idle

func _start_phase_transition() -> void:
	jump.target = marker_center.global_position
	var transition_states: Array[EnemyState] = [jump, hurt, idle, spawn]
	var transition_delays: Array[float] = [0.0, 0.0, 1.0, 0.0]
	phase_transition.start(transition_states, transition_delays)

func _advance_phase_transition() -> EnemyState:
	var next_state: EnemyState = phase_transition.advance(
		blackboard, entity.state_machine.current_state
	)

	if phase_transition.is_finished():
		blackboard.boss_phase = blackboard.BossPhase.Phase2
		spawn_timer = spawn_cooldown
		return walk

	return next_state

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

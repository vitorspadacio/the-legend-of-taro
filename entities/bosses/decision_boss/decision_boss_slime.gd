class_name DecisionBossSlime
extends DecisionEngine

@export var entity: Enemy

@export_category("States")
@export var death: BossDeathState
@export var hurt: BossHurtState
@export var idle: BossIdleState
@export var jump: BossJumpState
@export var spawn: EnemyState
@export var walk: EnemyState

var player: Player
var phase_transition := StateSequence.new()
var marker_nodes: Array[Marker2D] = []

var jump_cooldown := 5.0
var jump_timer := 0.0

var spawn_cooldown := 20.0
var spawn_timer := 0.0

func _ready() -> void:
	await super()
	blackboard.boss_phase = blackboard.BossPhase.Phase1

func _process(delta: float) -> void:
	jump_timer -= delta
	spawn_timer -= delta
	phase_transition.process(delta)

func decide() -> EnemyState:
	if not player:
		player = get_tree().get_first_node_in_group("player")
	blackboard.target = player

	if phase_transition.is_running():
		return _advance_phase_transition(Blackboard.BossPhase.Phase2)

	match blackboard.boss_phase:
		blackboard.BossPhase.Phase1:
			return phase_1()
		blackboard.BossPhase.Phase2:
			return phase_2()
		_:
			return phase_1()

func phase_1() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= entity.health.max_health * 0.5:
			_start_phase_transition()
			return _advance_phase_transition(Blackboard.BossPhase.Phase2)
		return hurt

	if not blackboard.can_decide:
		return null
	
	if jump_timer <= 0 and blackboard.target:
		return _jump()

	return idle

func phase_2() -> EnemyState:
	if blackboard.damage_source:
		if entity.health.current_health <= 0:
			return death
		return hurt

	if not blackboard.can_decide:
		return null
	
	if spawn_timer <= 0 and blackboard.target and spawn.can_spawn_again():
		spawn_timer = spawn_cooldown
		return spawn

	if jump_timer <= 0 and blackboard.target:
		return _jump()

	return walk

func _jump() -> EnemyState:
	jump_timer = randf_range(3 - jump_cooldown, jump_cooldown)
	if randf() < 0.7 or marker_nodes.is_empty():
		jump.target = blackboard.target.global_position
	else:
		jump.target = marker_nodes.pick_random().global_position
	return jump

func _start_phase_transition() -> void:
	jump.target = marker_nodes.front().global_position if not marker_nodes.is_empty() else entity.global_position
	var transition_states: Array[EnemyState] = [jump, hurt, idle, spawn]
	var transition_delays: Array[float] = [0.0, 0.0, 1.0, 0.0]
	phase_transition.start(transition_states, transition_delays)

func _advance_phase_transition(next_phase: Blackboard.BossPhase) -> EnemyState:
	var next_state: EnemyState = phase_transition.advance(
		blackboard, entity.state_machine.current_state
	)

	if phase_transition.is_finished():
		blackboard.boss_phase = next_phase
		spawn_timer = spawn_cooldown
		return walk

	return next_state

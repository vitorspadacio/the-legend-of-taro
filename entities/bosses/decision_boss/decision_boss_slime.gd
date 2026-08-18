class_name DecisionBossSlime
extends DecisionEngine

@export var entity: Enemy

@export var death: BossDeathState
@export var hurt: BossHurtState
@export var idle: BossIdleState
@export var jump: BossJumpState
@export var spawn: EnemyState
@export var walk: EnemyState

enum PhaseTransition {NONE, JUMP_TO_CENTER, HURT, WAIT, SPAWN}

var player: Player

var phase_transition := PhaseTransition.NONE
var transition_wait_time := 0.0
var transition_jump_started := false

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
	if phase_transition == PhaseTransition.WAIT:
		transition_wait_time -= delta

func decide() -> EnemyState:
	player = get_tree().get_first_node_in_group("player")
	blackboard.target = player

	if phase_transition != PhaseTransition.NONE:
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
	phase_transition = PhaseTransition.JUMP_TO_CENTER
	transition_jump_started = false
	jump.target = marker_center.global_position

func _advance_phase_transition() -> EnemyState:
	match phase_transition:
		PhaseTransition.JUMP_TO_CENTER:
			if not blackboard.can_decide:
				return null
			if not transition_jump_started:
				# Finish a pre-existing jump before starting the transition jump.
				if entity.state_machine.current_state == jump:
					return idle
				transition_jump_started = true
				return jump
			phase_transition = PhaseTransition.HURT
			return hurt

		PhaseTransition.HURT:
			if not blackboard.can_decide:
				return null
			phase_transition = PhaseTransition.WAIT
			transition_wait_time = 1.0
			blackboard.can_decide = false
			return idle

		PhaseTransition.WAIT:
			if transition_wait_time > 0.0:
				return null
			phase_transition = PhaseTransition.SPAWN
			return spawn

		PhaseTransition.SPAWN:
			if not blackboard.can_decide:
				return null
			blackboard.boss_phase = blackboard.BossPhase.Phase2
			spawn_timer = spawn_cooldown
			phase_transition = PhaseTransition.NONE
			return walk

	return null

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

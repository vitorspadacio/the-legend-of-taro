class_name StateSequence extends RefCounted

var states: Array[EnemyState] = []
var delays_after_state: Array[float] = []
var current_index := 0
var current_state_started := false
var delay_remaining := 0.0
var waiting_after_state := false
var can_start_while_locked := false
var running := false
var finished := false

func start(sequence: Array[EnemyState], delays: Array[float] = []) -> void:
	states = sequence.duplicate()
	delays_after_state = delays.duplicate()
	current_index = 0
	current_state_started = false
	delay_remaining = 0.0
	waiting_after_state = false
	can_start_while_locked = false
	running = not states.is_empty()
	finished = states.is_empty()

func process(delta: float) -> void:
	if delay_remaining > 0.0:
		delay_remaining = maxf(delay_remaining - delta, 0.0)

func advance(blackboard: Blackboard, active_state: EnemyState) -> EnemyState:
	if not running:
		return null

	if waiting_after_state:
		if delay_remaining > 0.0:
			return null
		waiting_after_state = false
		current_index += 1
		current_state_started = false
		can_start_while_locked = true

	if current_state_started:
		if not blackboard.can_decide:
			return null

		var delay := _get_delay(current_index)
		if delay > 0.0:
			delay_remaining = delay
			waiting_after_state = true
			blackboard.can_decide = false
			return null

		current_index += 1
		current_state_started = false

	if current_index >= states.size():
		running = false
		finished = true
		return null

	if not blackboard.can_decide and not can_start_while_locked:
		return null

	var next_state := states[current_index]
	current_state_started = true
	can_start_while_locked = false

	# StateMachine does not re-enter its current state. Restart it directly when
	# a sequence intentionally needs to run the same state again.
	if next_state == active_state:
		next_state.enter()
		return null

	return next_state

func is_running() -> bool:
	return running

func is_finished() -> bool:
	return finished

func _get_delay(index: int) -> float:
	if index < delays_after_state.size():
		return delays_after_state[index]
	return 0.0

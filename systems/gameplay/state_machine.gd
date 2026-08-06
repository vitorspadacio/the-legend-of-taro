@icon("res://assets/icons/state_machine.svg")
class_name StateMachine extends Node

@onready var state_label: Label = %StateLabel

var states: Array[State]
var player: Player
var enemy: Enemy

var current_state: State:
	get: return states.front()
	
var previous_state: State:
	get: return states[1]

func init_player(state_owner: Player) -> void:
	player = state_owner
	_initialize_states()

func init_enemy(state_owner: Enemy) -> void:
	enemy = state_owner
	_initialize_states()

func process(delta: float) -> void:
	change_state(current_state.process(delta))

func physics_process(delta: float) -> void:
	change_state(current_state.physics_process(delta))

func handle_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func _initialize_states() -> void:
	states = []
	
	for child in get_children():
		if child is PlayerState:
			states.append(child)
			child.player = player
		if child is EnemyState:
			states.append(child)
			child.enemy = enemy
		
	if states.size() == 0:
		return
		
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	%StateLabel.text = current_state.name
	
func change_state(new_state: State) -> void:
	if not new_state:
		return
		
	elif new_state == current_state:
		if enemy:
			current_state.re_enter()
		return
		
	states.push_front(new_state)
	previous_state.exit()
	current_state.enter()
	states.resize(3)
	
	%StateLabel.text = current_state.name

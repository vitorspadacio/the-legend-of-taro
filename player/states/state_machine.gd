@icon("res://assets/icons/state_machine.svg")
class_name StateMachine extends Node

var states: Array[PlayerState]

var current_state: PlayerState:
	get: return states.front()
	
var previous_state: PlayerState:
	get: return states[1]

func _ready() -> void:
	_initialize_states()

func process(delta: float) -> void:
	current_state.process(delta)

func physics_process(delta: float) -> void:
	current_state.physics_process(delta)

func handle_input(event: InputEvent) -> void:
	current_state.handle_input(event)

func _initialize_states() -> void:
	states = []
	
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
		
	if states.size() == 0:
		return
		
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	
func change_state(new_state: PlayerState) -> void:
	if new_state == null:
		return
		
	elif new_state == current_state:
		return
		
	states.push_front(new_state)
	previous_state.exit()
	current_state.enter()
	states.resize(3)
	
	$Label.text = current_state.name
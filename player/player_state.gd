@icon("res://assets/icons/state.svg")

class_name PlayerState extends State

@onready var attack: PlayerState = %Attack
@onready var hurt: PlayerState = %Hurt
@onready var idle: PlayerState = %Idle
@onready var roll: PlayerState = %Roll
@onready var swing: PlayerState = %Swing
@onready var walk: PlayerState = %Walk

var player: Player

func can_enter() -> bool:
	return true

func get_command_state() -> PlayerState:
	if player.input.attack and attack.can_enter():
		return attack
	elif player.input.roll and roll.can_enter():
		return roll
	elif player.input.swing and swing.can_enter():
		return swing
	elif player.input.walk != Vector2.ZERO:
		return walk
	elif player.input.idle:
		return idle
	return null

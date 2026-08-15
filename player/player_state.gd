@icon("res://assets/icons/state.svg")

class_name PlayerState extends State

@onready var attack: PlayerState = %Attack
@onready var hurt: PlayerState = %Hurt
@onready var idle: PlayerState = %Idle
@onready var jump: PlayerState = %Jump
@onready var roll: PlayerState = %Roll
@onready var swing: PlayerState = %Swing
@onready var walk: PlayerState = %Walk

var player: Player

func can_enter() -> bool:
	return true

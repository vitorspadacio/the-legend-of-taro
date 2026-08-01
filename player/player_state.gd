@icon("res://assets/icons/state.svg")

class_name PlayerState extends Node

@onready var attack: PlayerState = %Attack
@onready var idle: PlayerState = %Idle
@onready var roll: PlayerState = %Roll
@onready var swing: PlayerState = %Swing
@onready var walk: PlayerState = %Walk

var next_state: PlayerState = null
var player: Player
var state_name: String

func init() -> void:
	pass
	
func enter() -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null
	
func process(_delta: float) -> PlayerState:
	return null

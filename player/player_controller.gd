@icon("res://assets/icons/decision_engine.svg")
class_name PlayerController extends Node

var attack := false
var idle := false
var roll := false
var swing := false
var walk := Vector2.ZERO

func decide(event: InputEvent) -> void:
	walk = Input.get_vector("left", "right", "up", "down")
	attack = event.is_action_pressed("attack")
	roll = event.is_action_pressed("roll")
	swing = !swing if event.is_action_pressed("swing_test") else swing
	idle = walk == Vector2.ZERO

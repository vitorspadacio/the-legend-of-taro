class_name PlayerController extends Node

var attack := false
var idle := false
var roll := false
var swing := false
var walk := Vector2.ZERO

func decide() -> void:
	attack = Input.is_action_just_pressed("attack")
	idle = walk == Vector2.ZERO
	roll = Input.is_action_just_pressed("roll")
	swing = Input.is_action_just_pressed("swing_test")
	walk = Input.get_vector("left", "right", "up", "down")
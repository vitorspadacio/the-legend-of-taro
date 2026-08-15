class_name InputComponent extends Node

var attack := false
var direction := Vector2.ZERO
var idle := false
var jump := false
var roll := false
var swing := false

func update_commands() -> void:
	attack = Input.is_action_just_pressed("attack")
	direction = Input.get_vector("left", "right", "up", "down")
	idle = direction == Vector2.ZERO
	jump = Input.is_action_just_pressed("jump")
	roll = Input.is_action_just_pressed("roll")
	swing = !swing if Input.is_action_just_pressed("swing_test") else swing

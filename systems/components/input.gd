class_name InputComponent extends Node

var attack := false
var idle := false
var roll := false
var swing := false
var walk := Vector2.ZERO

func update() -> void:
	walk = Input.get_vector("left", "right", "up", "down")
	attack = Input.is_action_just_pressed("attack")
	roll = Input.is_action_just_pressed("roll")
	swing = !swing if Input.is_action_just_pressed("swing_test") else swing
	idle = walk == Vector2.ZERO

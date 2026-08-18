class_name MovementComponent extends Node

signal direction_changed(direction: Vector2)

const DIRECTION_NAMES := {
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
}

@export var acceleration := 2500.00
@export var body: PhysicsBody2D
@export var speed := 100.00

var actual_speed := 0.0
var direction := Vector2(0, 0)
var direction_name: String:
	get(): return _get_direction_name()
var facing_direction := Vector2.DOWN
var lock_direction := false

func move(multiplier: float = 1.0, delta: float = 0.5) -> void:
	update_direction()
	actual_speed = speed * multiplier
	body.velocity = body.velocity.move_toward(
		direction * actual_speed,
		acceleration * delta)
	body.move_and_slide()

func roll(multiplier: float = 1.25) -> void:
	update_direction()
	actual_speed = speed * multiplier
	body.velocity = facing_direction * actual_speed
	body.move_and_slide()

func knockback(knockback_speed: float, knockback_direction: Vector2, delta: float) -> void:
	actual_speed = knockback_speed
	body.velocity = body.velocity.move_toward(
		knockback_direction * actual_speed,
		acceleration * delta)
	body.move_and_slide()

func update_direction(new_direction: Vector2 = direction) -> void:
	direction = new_direction
	direction_changed.emit(direction)
	if direction != Vector2.ZERO and not lock_direction:
		facing_direction = _get_cardinal_direction()

func _get_direction_name() -> String:
	return DIRECTION_NAMES.get(facing_direction, "down")

func _get_cardinal_direction() -> Vector2:
	if absf(direction.x) > absf(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0 else Vector2.UP

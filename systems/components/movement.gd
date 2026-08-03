class_name MovementComponent extends Node

const DIRECTION_NAMES := {
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
}

const MULTIPLIER := 10

signal direction_changed(direction: Vector2, direction_name: String)

@export var animation: AnimationPlayer
@export var body: PhysicsBody2D
@export var speed := 100.00

var actual_speed := 0.0
var direction := Vector2(0, 0)
var direction_name: String:
	get(): return _get_direction_name()
var facing_direction := Vector2.DOWN
var lock_direction := false

func stop() -> void:
	actual_speed = 0.0

func move(multiplier: float = 1.0) -> void:
	update_direction()
	actual_speed = speed * multiplier
	body.velocity = direction * actual_speed
	body.move_and_slide()

func roll(multiplier: float = 1.25) -> void:
	update_direction()
	actual_speed = speed * multiplier
	body.velocity = facing_direction * actual_speed
	body.move_and_slide()

func knockback(knockback_speed: float, knockback_direction: Vector2) -> void:
	actual_speed = knockback_speed
	body.velocity = knockback_direction * actual_speed
	body.move_and_slide()

func update_direction() -> void:
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	if direction != Vector2.ZERO and not lock_direction:
		facing_direction = _get_cardinal_direction()
	direction_changed.emit(direction, _get_direction_name())

func _get_direction_name() -> String:
	return DIRECTION_NAMES.get(facing_direction, "down")

func _get_cardinal_direction() -> Vector2:
	if absf(direction.x) > absf(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0 else Vector2.UP

class_name Player extends CharacterBody2D

const DIRECTION_NAMES := {
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
}

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine

@export var move_speed := 100.00
@export var controller := PlayerController

var base_move_speed := 100
var direction := Vector2(0, 0)
var facing_direction := Vector2.DOWN

##### Core #####

func _ready() -> void:
	if get_tree().get_first_node_in_group("player") != self:
		self.queue_free()
	self.call_deferred("reparent", get_tree().root)

func _process(delta: float) -> void:
	update_direction()
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	move_and_slide()
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

##### Functions #####

func update_direction() -> void:
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	update_animation()

func update_animation() -> void:
	if direction != Vector2.ZERO:
		facing_direction = _get_cardinal_direction()

	animation.play("%s_%s" % [state_machine.current_state.state_name, _get_direction_name()])

func _get_direction_name() -> String:
	return DIRECTION_NAMES.get(facing_direction, "down")

func _get_cardinal_direction() -> Vector2:
	if absf(direction.x) > absf(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0 else Vector2.UP

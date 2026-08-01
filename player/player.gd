class_name Player extends CharacterBody2D

const DIRECTION_NAMES := {
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
}

const WEAPONS := {
	"axe": "uid://c75as5cuma22p",
	"katana": "uid://bden8i5f5wdrs",
	"pickaxe": "uid://d1ihaoqhyix5j"
}

signal damage_taken

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var controller: PlayerController = $PlayerController
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine

@onready var damage_area: DamageArea = $DamageArea

@export var move_speed := 100.00

var base_move_speed := 100
var direction := Vector2(0, 0)
var facing_direction := Vector2.DOWN
var lock_direction := false
var selected_weapon := WEAPONS.axe

##### Core #####

func _ready() -> void:
	if get_tree().get_first_node_in_group("player") != self:
		self.queue_free()
		return
	state_machine.init(self)
	self.call_deferred("reparent", get_tree().root)

	damage_area.damage_taken.connect(_on_damage_taken)

func _process(delta: float) -> void:
	update_direction()
	update_animation()
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	controller.decide(event)
	state_machine.handle_input(event)

##### Functions #####

func update_direction() -> void:
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)

func update_animation() -> void:
	if direction != Vector2.ZERO and not lock_direction:
		facing_direction = _get_cardinal_direction()

	animation.play("%s_%s" % [state_machine.current_state.state_name, _get_direction_name()])

func _get_direction_name() -> String:
	return DIRECTION_NAMES.get(facing_direction, "down")

func _get_cardinal_direction() -> Vector2:
	if absf(direction.x) > absf(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0 else Vector2.UP

##### Side Effects #####

func _on_damage_taken(attack_area: AttackArea) -> void:
	damage_taken.emit()
	print("Acertou com dano %s" % attack_area.damage)

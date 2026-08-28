class_name DialogComponent extends Area2D

const DIALOG_BUUBLE = preload("uid://cgh2qhgt12y8h")
const DIALOG_BOX = preload("uid://bxbgy3sqkjgwp")

signal dialog_started(direction: Vector2)
signal dialog_ended

@export var entity: CharacterBody2D
@export var lines: Array[DialogLine]

var box: DialogBox
var buuble: Node2D
var is_in_dialog: bool = false
var is_in_range: bool = false
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	set_collision_mask_value(Constants.CollisionLayers.player, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	create_buuble()


func create_buuble() -> void:
	buuble = DIALOG_BUUBLE.instantiate()
	buuble.visible = false
	buuble.global_position.y -= 20
	add_sibling.call_deferred(buuble)


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	is_in_range = true
	buuble.visible = true


func _on_body_exited(_body: Node2D) -> void:
	is_in_range = false
	buuble.visible = false


func _on_dialog_end() -> void:
	is_in_dialog = false
	buuble.visible = true
	player.block_input = false
	dialog_ended.emit()


func _process(_delta: float) -> void:
	if box:
		return

	if is_in_range and Input.is_action_just_pressed("action"):
		start_dialog()


func start_dialog() -> void:
	player.block_input = true
	is_in_dialog = true
	buuble.visible = false
	dialog_started.emit(_get_entity_direction())
	_create_dialog_box()


func _create_dialog_box() -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	box = DIALOG_BOX.instantiate()
	box.has_no_more_lines.connect(_on_dialog_end)
	box.dialog = lines
	box.global_position = camera.global_position * 0.5
	box.global_position.x -= 160
	get_tree().current_scene.add_child(box)


func _get_entity_direction() -> Vector2:
	var direction := player.global_position - entity.global_position

	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0 else Vector2.UP

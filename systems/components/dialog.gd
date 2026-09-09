class_name DialogComponent extends Area2D

const DIALOG_BUUBLE = preload("uid://cgh2qhgt12y8h")
const DIALOG_BOX = preload("uid://bxbgy3sqkjgwp")

enum DialogTypes {
	NORMAL = 0,
	NO_ACTOR = 1,
	CENTER = 2
}

signal dialog_started(direction: Vector2)
signal dialog_ended

@export var entity: Node2D
@export var pages: Array[DialogPage]
@export var style: DialogTypes

var box: DialogBox
var buuble: Node2D
var current_index: int
var is_in_dialog: bool = false
var is_in_range: bool = false
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	set_collision_mask_value(Constants.CollisionLayers.player, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	current_index = 0
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
	player.end_freeze()
	dialog_ended.emit()

	if pages[current_index].dies_after_one_read:
		current_index += 1


func _process(_delta: float) -> void:
	if box:
		return

	if is_in_range and Input.is_action_just_pressed("action"):
		start_dialog()


func start_dialog() -> void:
	player.start_freeze()
	is_in_dialog = true
	buuble.visible = false
	if entity != null:
		player.movement.facing_direction = _get_entity_direction() * -1
		dialog_started.emit(_get_entity_direction())
	check_pages_condition()
	_create_dialog_box()


func _create_dialog_box() -> void:
	var general_hud = get_tree().get_first_node_in_group("general_hud")
	box = DIALOG_BOX.instantiate()
	box.has_no_more_lines.connect(_on_dialog_end)
	box.style = style
	box.dialog = pages[current_index].lines
	general_hud.add_child(box)


func _get_entity_direction() -> Vector2:
	var direction := player.global_position - entity.global_position

	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	return Vector2.DOWN if direction.y > 0 else Vector2.UP


func check_pages_condition() -> void:
	for page in pages:
		var page_index = pages.find(page)
		if page.item_condition and page_index >= current_index:
			var item = page.item_condition

			if player.inventory.has_item_with_quantity(item, page.quantity):
				current_index = pages.find(page)

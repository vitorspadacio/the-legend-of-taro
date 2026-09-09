class_name Npc extends CharacterBody2D

@onready var collision: CollisionShape2D = $Collision
@export var sprite: Sprite2D
@export var upgrade: Pickable
@export var event_dialog: DialogComponent

@export_category("components")
@export var animation: AnimationComponent
@export var dialog: DialogComponent
@export var movement: MovementComponent

##### Core #####

func _ready() -> void:
	dialog.dialog_started.connect(_on_dialog_start)
	dialog.dialog_ended.connect(_on_dialog_ended)
	animation.play("idle")

func _on_dialog_start(direction: Vector2) -> void:
	movement.update_direction(direction)
	animation.direction_name = movement.direction_name
	animation.play()

func _on_dialog_ended() -> void:
	print(dialog.current_index)
	if dialog.current_index == 2:
		give_upgrade()
	movement.update_direction(Vector2.DOWN)
	animation.direction_name = movement.direction_name
	animation.play()

func give_upgrade() -> void:
	print(upgrade)
	var player = get_tree().get_first_node_in_group("player")
	player.take_upgrade(upgrade)
	await get_tree().create_timer(2.0).timeout
	event_dialog.start_dialog()

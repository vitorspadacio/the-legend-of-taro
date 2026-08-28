class_name Npc extends CharacterBody2D

@onready var collision: CollisionShape2D = $Collision
@export var sprite: Sprite2D

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
	movement.update_direction(Vector2.DOWN)
	animation.direction_name = movement.direction_name
	animation.play()

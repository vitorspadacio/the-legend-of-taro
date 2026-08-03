class_name AnimationComponent extends Node

@export var animation_player: AnimationPlayer
@export var movement: MovementComponent

var current_animation_name: String

func _ready() -> void:
	movement.direction_changed.connect(_on_direction_changed)

func play(animation_name: String) -> void:
	current_animation_name = animation_name
	animation_player.play("%s_%s" % [current_animation_name, movement.direction_name])

func _on_direction_changed(_d: Vector2, _dn: String) -> void:
	play(current_animation_name)
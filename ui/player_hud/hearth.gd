class_name Heart
extends Control

@onready var sprite: Sprite2D = $Sprite2D

func set_state(state: int) -> void:
	sprite.frame = clampi(state, 0, 4)
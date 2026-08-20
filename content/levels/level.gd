class_name Level extends Node2D

@onready var environment_area: EnvironmentArea = %EnvironmentArea
@onready var screen_grid_ref: TextureRect = $ScreenGridRef

func _ready() -> void:
	screen_grid_ref.visible = false

class_name JumpComponent
extends Node

signal height_changed(height: float)
signal jump_started
signal jump_finished

@export var jump_curve: Curve
@export var jump_height := 15.0
@export var jump_duration := 0.5
@export var raycast_2d: RayCast2D

var height := 0.0
var is_jumping := false
var jump_time := 0.0

func jump() -> void:
	if is_jumping:
		return

	is_jumping = true
	jump_time = 0.0
	jump_started.emit()

func can_jump() -> bool:
	if not raycast_2d.is_colliding():
		return true

	var tile_map := raycast_2d.get_collider() as TileMapLayer

	if tile_map == null:
		return true

	var collision_point := raycast_2d.get_collision_point()

	var cell := tile_map.local_to_map(
		tile_map.to_local(collision_point)
	)
	var tiledata := tile_map.get_cell_tile_data(cell)

	if tiledata is TileData and tiledata.has_custom_data("height"):
		return height >= tiledata.get_custom_data("height")

	return false

func _process(delta: float) -> void:
	if not is_jumping:
		return

	jump_time += delta

	var progress := jump_time / jump_duration

	if progress >= 1.0:
		progress = 1.0
		is_jumping = false

	if can_jump():
		height = jump_curve.sample(progress) * jump_height
	else:
		height = jump_curve.sample(progress) * 10.0
	height_changed.emit(height)

	if not is_jumping:
		jump_finished.emit()

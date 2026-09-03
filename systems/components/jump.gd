class_name JumpComponent
extends Node

signal height_changed(height: float)
signal jump_started
signal jump_finished

@export var jump_curve: Curve
@export var jump_height := 15.0
@export var jump_duration := 0.5
@export var raycast_2d: RayCast2D

@export var gravity_up := 400.0
@export var gravity_down := 500.0

var gravity := 0.0
var height := 0.0
var is_jumping := false
var jump_time := 0.0
var velocity := 0.0

func _ready() -> void:
	gravity = (8.0 * jump_height) / (jump_duration * jump_duration)

func jump() -> void:
	if is_jumping:
		return

	is_jumping = true
	velocity = sqrt(2.0 * gravity * jump_height)
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
		print("can jump: ", height >= tiledata.get_custom_data("height"))
		return height >= tiledata.get_custom_data("height")

	return false

func _process(delta: float) -> void:
	if not is_jumping:
		return
			
	var current_gravity := gravity_up

	if velocity < 0.0:
			current_gravity = gravity_down

	velocity -= current_gravity * delta
	height += velocity * delta

	if height <= 0.0 and velocity < 0.0:
		height = 0.0
		velocity = 0.0
		is_jumping = false
		jump_finished.emit()

	height_changed.emit(height)

	# var progress := jump_time / jump_duration

	# if progress >= 1.0:
	# 	progress = 1.0
	# 	is_jumping = false

	# if can_jump():
	# 	height = jump_curve.sample(progress) * jump_height
	# else:
	# 	height = jump_curve.sample(progress) * 10.0
	# height_changed.emit(height)

	# if not is_jumping:
	# 	jump_finished.emit()

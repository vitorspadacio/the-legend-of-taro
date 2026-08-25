@icon("../environment/icon_environment_area.png")
class_name EnvironmentArea extends Area2D

signal environment_changed(environment)

func _ready() -> void:
	body_shape_entered.connect(_on_player_enter_environment_shape)
	monitorable = false

func _on_player_enter_environment_shape(
	_body_rid,
	_body,
	_body_shape_index,
	local_shape_index):
	var shape = get_child(local_shape_index)
	if shape is EnvironmentShape:
		environment_changed.emit(shape.resource_environment)

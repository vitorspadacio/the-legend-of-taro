@icon("../environment/icon_environment_area.png")
extends Area2D
class_name EnvironmentArea

signal environment_changed(environment)

func _ready() -> void:
	body_shape_entered.connect(on_player_enter_environment_shape)
	monitorable = false

func on_player_enter_environment_shape(body_rid, body, body_shape_index, local_shape_index):
	var shape = get_child(local_shape_index)
	if shape is EnvironmentShape:
		environment_changed.emit()

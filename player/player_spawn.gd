class_name PlayerSpawn extends Node2D

@export var respawn: Teleport

func _ready() -> void:
	visible = false
	await get_tree().process_frame

	if get_tree().get_first_node_in_group("player"):
		print('Player already exists')
		return

	print('Player not found')

	var player = load("uid://c5dtb51gcaxvy").instantiate()
	player.respawn = respawn
	var camera = get_tree().get_first_node_in_group("camera")
	camera.target = player
	get_tree().root.add_child(player)
	player.global_position = self.global_position

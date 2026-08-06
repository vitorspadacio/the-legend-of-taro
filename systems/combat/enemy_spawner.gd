class_name EnemySpawner extends Node2D

@export var enemy_scene: PackedScene
@export var respawn_delay := 4.0

var spawn_timer: SceneTreeTimer

func _process(_delta: float) -> void:
	if enemy_scene == null:
		return

	if _has_enemy_on_screen():
		spawn_timer = null
		return

	if spawn_timer == null:
		spawn_timer = get_tree().create_timer(respawn_delay)
		spawn_timer.timeout.connect(_spawn_enemy)

func _spawn_enemy() -> void:
	spawn_timer = null

	if enemy_scene == null or _has_enemy_on_screen():
		return

	var enemy := enemy_scene.instantiate() as Node2D
	get_parent().add_child(enemy)
	enemy.global_position = global_position

func _has_enemy_on_screen() -> bool:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy) and enemy.is_inside_tree():
			return true
	return false

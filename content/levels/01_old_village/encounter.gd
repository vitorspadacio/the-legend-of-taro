class_name Encounter extends Node2D

@export var barrier_tile: TileMapLayer
@export var dialog: DialogComponent
@export var item_to_start: Pickable
@export var music: AudioStream
@export var navigation_region: NavigationRegion2D
@export var starter: Area2D
@export var spawn_points: Array[Node]

var dead_enemies_count := 0

func _ready() -> void:
	barrier_tile.visible = false
	barrier_tile.collision_enabled = false
	if item_to_start:
		print("registro item")
		item_to_start.item_picked.connect(start)
	if starter:
		print("registro starter")
		starter.body_entered.connect(_on_enter_starter)


func _on_enter_starter(player: Player) -> void:
	starter.body_entered.disconnect(_on_enter_starter)
	if player:
		player.freeze()
		start()


func start() -> void:
	print("começo")
	await get_tree().create_timer(2.0).timeout
	await show_barrier()
	if dialog:
		dialog.start_dialog()
		await dialog.dialog_ended

	Audio.play_music(music)
	await spawn_enemies()


func show_barrier() -> void:
	barrier_tile.visible = true
	barrier_tile.collision_enabled = true
	VisualEffects.create_sparkle(barrier_tile.global_position)
	await flash_blue()


func spawn_enemies() -> void:
	var player = get_tree().get_first_node_in_group("player")
	for spawn_point: EnemySpawnPoint in spawn_points:
		var spawned = spawn_point.enemy_scene.instantiate() as Enemy
		spawned.global_position = spawn_point.global_position
		VisualEffects.create_smoke(spawned.global_position)
		add_sibling.call_deferred(spawned)
		await get_tree().process_frame
		spawned.blackboard.target = player
		spawned.health.died.connect(_count_dead_enemies)


func flash_blue() -> void:
	var tween := create_tween()
	for i in 4:
		tween.tween_property(barrier_tile, "modulate", Color.BLUE, 0.05)
		tween.tween_property(barrier_tile, "modulate", Color.WHITE, 0.01)
	await tween.finished


func flash_green() -> void:
	var tween := create_tween()
	for i in 4:
		tween.tween_property(barrier_tile, "modulate", Color.GREEN, 0.05)
		tween.tween_property(barrier_tile, "modulate", Color.WHITE, 0.07)
	await tween.finished


func end() -> void:
	Audio.stop_music()
	await get_tree().create_timer(2.5).timeout
	VisualEffects.create_sparkle(barrier_tile.global_position)
	await flash_green()
	var world := get_tree().get_first_node_in_group("world") as WorldManager
	world.apply_environment(world.current_resource)
	barrier_tile.visible = false
	barrier_tile.collision_enabled = false


func _count_dead_enemies() -> void:
	dead_enemies_count += 1
	if dead_enemies_count == spawn_points.size():
		end()

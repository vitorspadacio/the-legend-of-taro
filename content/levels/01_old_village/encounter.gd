class_name Encounter extends Node2D

@onready var barrier_collision: CollisionShape2D = %BarrierCollision
@onready var barrier_tile: TileMapLayer = $Barrier/BarrierTile
@onready var katana: Pickable = %Katana
@onready var spawn_points: Array[Node] = $Enemies.get_children()

var dead_enemies_count := 0

func _ready() -> void:
	barrier_collision.set_deferred("disabled", true)
	barrier_collision.set_deferred("visible", false)
	barrier_tile.visible = false
	barrier_tile.collision_enabled = false
	katana.item_picked.connect(start)


func start() -> void:
	await get_tree().create_timer(3.0).timeout
	barrier_tile.visible = true
	barrier_tile.collision_enabled = true
	VisualEffects.create_sparkble(barrier_tile.global_position)
	VisualEffects.create_sparkble(barrier_tile.global_position + Vector2(16, 0))
	VisualEffects.create_sparkble(barrier_tile.global_position + Vector2(-16, 0))
	barrier_collision.set_deferred("disabled", false)
	barrier_collision.set_deferred("visible", true)
	var player = get_tree().get_first_node_in_group("player")
	for spawn_point: EnemySpawnPoint in spawn_points:
		var spawned = spawn_point.enemy_scene.instantiate() as Enemy
		spawned.global_position = spawn_point.global_position
		VisualEffects.create_smoke(spawned.global_position)
		add_sibling.call_deferred(spawned)
		await get_tree().process_frame
		spawned.blackboard.target = player
		spawned.health.died.connect(_count_dead_enemies)


func end() -> void:
	barrier_tile.visible = false
	barrier_tile.collision_enabled = false
	barrier_collision.set_deferred("disabled", true)
	barrier_collision.set_deferred("visible", false)
	queue_free()


func _count_dead_enemies() -> void:
	dead_enemies_count += 1


func _process(_delta: float) -> void:
	if dead_enemies_count == spawn_points.size():
		end()

class_name LootDropper extends Marker2D

@export var items: Array[LootData]

func _ready() -> void:
	if owner is Enemy:
		owner.health.died.connect(drop_loot)


func drop_loot() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	for item in items:
		var max_health_percent = player.health.max_health * item.drop_by_player_health
		if max_health_percent > 0 and player.health.current_health <= max_health_percent:
			drop_item(item)

		if item.drop_chance <= randf():
			continue
		
		drop_item(item)


func drop_item(item: LootData) -> void:
		var drop_scene = load(item.item)
		var count := randi_range(item.minimum, item.maximum)
		for j in count:
			var drop = drop_scene.instantiate()
			drop.global_position = global_position
			get_tree().current_scene.add_sibling.call_deferred(drop)
			if drop is CharacterBody2D:
				var x = randf_range(-100, 100)
				var y = randf_range(-100, 100)
				drop.velocity = Vector2(x, y)
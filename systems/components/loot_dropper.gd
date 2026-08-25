class_name LootDropper extends Marker2D

@export var items: Array[LootData]

func _ready() -> void:
	owner.health.died.connect(drop_loot)

func drop_loot() -> void:
	for item in items:
		if item.drop_chance <= randf():
			continue

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

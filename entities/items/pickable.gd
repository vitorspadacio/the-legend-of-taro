class_name Pickable extends Node2D

@export var effect: Callable
@export var item: ItemData
@export var sound: AudioStream
@export var sprite: Sprite2D

@onready var area: Area2D = $Area2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Player) -> void:
	Audio.play_spatial_sound(sound, global_position)
	body.inventory.add_item(item)
	queue_free()

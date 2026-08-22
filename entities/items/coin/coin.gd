extends Node2D

const SOUND = preload("uid://db8lhbbefi2ok")

@onready var area: Area2D = $Area2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(a: Node2D) -> void:
	if a is Player:
		Audio.play_spatial_sound(SOUND, global_position)
		queue_free()

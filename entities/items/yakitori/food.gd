extends Pickable

@export var heal_amount: int

func _on_body_entered(body: Player) -> void:
	Audio.play_spatial_sound(sound, global_position)
	VisualEffects.create_pick(global_position)
	body.health.heal(heal_amount)
	queue_free()

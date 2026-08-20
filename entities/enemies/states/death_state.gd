@icon("res://assets/icons/state.svg")
class_name EnemyDeathState extends EnemyState

@export var sound: AudioStream

func enter() -> void:
	Audio.play_spatial_sound(sound, enemy.global_position)
	VisualEffects.create_smoke(enemy.global_position)
	enemy.blackboard.damage_source = null
	enemy.blackboard.can_decide = false
	enemy.queue_free()

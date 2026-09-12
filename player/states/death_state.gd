@icon("res://assets/icons/state.svg")
class_name PlayerDeathState extends PlayerState

@export var force := 75.0
@export var sound: AudioStream

var direction := Vector2.ZERO

func init() -> void:
	player.health.died.connect(_on_death)
	
func enter() -> void:
	Audio.play_spatial_sound(sound, player.global_position)
	player.set_collision_layer_value(6, false)
	player.drop_coins()
	player.animation.play_no_direction("death")
	player.attack_area.set_deferred("monitorable", false)
	player.animation.animation_player.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	player.animation.animation_player.animation_finished.disconnect(_on_animation_finished)
	player.set_collision_layer_value(6, true)

func _on_animation_finished(animation_name: String) -> void:
	if animation_name != "death":
		return
	await get_tree().create_timer(3.0).timeout
	VisualEffects.create_smoke(player.global_position)
	player.visible = false
	await get_tree().create_timer(1.0).timeout
	player.respawn_player()
	
func _on_death() -> void:
	player.state_machine.change_state(self)

func physics_process(delta: float) -> PlayerState:
	player.movement.knockback(force, direction, delta)
	return null

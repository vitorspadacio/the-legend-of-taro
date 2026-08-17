@icon("res://assets/icons/state.svg")
class_name PlayerDeathState extends PlayerState

func init() -> void:
	player.health.died.connect(_on_death)
	
func enter() -> void:
	player.animation.play_no_direction("death")
	player.attack_area.call_deferred("monitorable", false)
	player.animation.animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(animation_name: String) -> void:
	if animation_name != "death":
		return
	await get_tree().create_timer(3.0).timeout
	VisualEffects.create_smoke(player.global_position)
	player.visible = false
	
func _on_death() -> void:
	player.state_machine.change_state(self)

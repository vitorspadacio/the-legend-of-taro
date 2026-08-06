@icon("res://assets/icons/state.svg")
class_name PlayerHurtState extends PlayerState

@export var force := 50.0
@export var invulnerable_duration := 0.2
@export var sound_effect: AudioStream

var direction := Vector2.ZERO
var time: float = 0.0

func init() -> void:
	player.damage_taken.connect(_on_hurt)
	
func enter() -> void:
	player.animation.play("hurt")
	time = player.animation.animation_player.current_animation_length + 0.15
	player.damage_area.make_invulnerable(invulnerable_duration)
	
func exit() -> void:
	pass

func physics_process(delta: float) -> PlayerState:
	player.movement.knockback(force, direction, delta)
	return null
	
func process(delta: float) -> PlayerState:
	time -= delta
	if time <= 0:
		return idle
	return null

func _on_hurt(attack_area: AttackArea) -> void:
	player.state_machine.change_state(self)
	direction = (player.global_position - attack_area.global_position).normalized()

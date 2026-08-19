@icon("res://assets/icons/state.svg")
class_name PlayerHurtState extends PlayerState

@export var force := 75.0
@export var invulnerable_duration := 0.75
@export var sound_effect: AudioStream

var buffered_attack := false
var direction := Vector2.ZERO
var time: float = 0.0

func init() -> void:
	player.damage_taken.connect(_on_hurt)
	
func enter() -> void:
	player.animation.play("hurt")
	time = player.animation.animation_player.current_animation_length
	player.damage_area.make_invulnerable(time + invulnerable_duration)
	buffered_attack = false
	
func exit() -> void:
	pass

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("attack"):
		buffered_attack = true

	return null

func physics_process(delta: float) -> PlayerState:
	player.movement.knockback(force, direction, delta)
	return null
	
func process(delta: float) -> PlayerState:
	time -= delta
	if time <= 0:
		return idle
	return null

func _on_hurt(attack_area: AttackArea) -> void:
	if player.health.current_health == 0:
		return
	player.state_machine.change_state(self)
	direction = (player.global_position - attack_area.global_position).normalized()

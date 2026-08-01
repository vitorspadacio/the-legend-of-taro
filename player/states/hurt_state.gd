@icon("res://assets/icons/state.svg")
class_name PlayerHurtState extends PlayerState

@export var invulnerable_duration: float = 0.2
@export var move_speed: float = 15
@export var sound_effect: AudioStream

var direction := Vector2.ZERO
var time: float = 0.0

func init() -> void:
	state_name = "hurt"
	player.damage_taken.connect(_on_hurt)
	
func enter() -> void:
	time = player.animation.current_animation_length
	player.damage_area.make_invulnerable(invulnerable_duration)
	# Audio.play_spatial_sound(sound_effect, player.global_position)
	# VisualEffects.camera_shake(2)
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> PlayerState:
	player.velocity = move_speed * direction
	return null
	
func process(delta: float) -> PlayerState:
	time -= delta
	if time <= 0:
		return idle
	return null

func _on_hurt(attack_area: AttackArea) -> void:
	player.state_machine.change_state(self)

	direction = (player.global_position - attack_area.global_position).normalized()
	if direction == Vector2.ZERO:
		direction = - player.facing_direction

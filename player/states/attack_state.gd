class_name PlayerAttackState extends PlayerState

@export var speed: float = 50
@export var sound: AudioStream

@onready var attack_sprite: Sprite2D = %AttackSprite

func init() -> void:
	attack_sprite.visible = false
	
func enter() -> void:
	player.animation.animation_finished.connect(_on_animation_finished)
	# Audio.play_spatial_sound(sound_effect, player.attack_area.global_position, false, true)
	
func exit() -> void:
	player.animation.clear_queue()
	player.animation.animation_finished.disconnect(_on_animation_finished)
	attack_sprite.visible = false
	next_state = null

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity = player.direction * speed
	return null
	
func process(_delta: float) -> PlayerState:
	return next_state

func _on_animation_finished(_animation_name: String) -> void:
	next_state = idle

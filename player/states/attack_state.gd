class_name PlayerAttackState extends PlayerState

@export var cooldown := 0.25
@export var sound: AudioStream

@onready var attack_sprite: Sprite2D = %AttackSprite

var next_attack_time := 0.0

func init() -> void:
	state_name = "attack"
	attack_sprite.visible = false
	
func enter() -> void:
	attack_sprite.texture = load(player.selected_weapon)
	attack_sprite.visible = true
	player.animation.animation_finished.connect(_on_animation_finished)
	player.lock_direction = true
	player.velocity = Vector2.ZERO
	# Audio.play_spatial_sound(sound_effect, player.attack_area.global_position, false, true)
	
func exit() -> void:
	player.animation.clear_queue()
	player.animation.animation_finished.disconnect(_on_animation_finished)
	attack_sprite.visible = false
	player.lock_direction = false
	next_state = null
	next_attack_time = Time.get_ticks_msec() / 1000.0 + cooldown

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO
	return null
	
func process(_delta: float) -> PlayerState:
	return next_state

func can_enter() -> bool:
	return Time.get_ticks_msec() / 1000.0 >= next_attack_time

func _on_animation_finished(_animation_name: String) -> void:
	next_state = idle

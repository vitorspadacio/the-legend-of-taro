class_name PlayerAttackState extends PlayerState

@export var cooldown := 0.25
@export var sound: AudioStream

var next_attack_time := 0.0

func init() -> void:
	state_name = "attack"
	player.sprite_attack.visible = false
	
func enter() -> void:
	player.animation.animation_finished.connect(_on_animation_finished)
	player.lock_direction = true
	player.sprite_attack.texture = load(player.selected_weapon)
	player.sprite_attack.visible = true
	player.velocity = Vector2.ZERO
	# Audio.play_spatial_sound(sound_effect, player.attack_area.global_position, false, true)
	
func exit() -> void:
	player.animation.animation_finished.disconnect(_on_animation_finished)
	player.animation.clear_queue()
	player.lock_direction = false
	player.sprite_attack.visible = false
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

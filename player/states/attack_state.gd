class_name PlayerAttackState extends PlayerState

@export var cooldown := 0.001
@export var sound: AudioStream

var selected_weapon: WeaponData

func init() -> void:
	player.sprite_attack.visible = false
	
func enter() -> void:
	selected_weapon = player.inventory.current_weapon
	player.attack_area.damage = selected_weapon.damage
	player.animation.play("attack")
	player.animation.animation_player.animation_finished.connect(_on_animation_finished)
	player.sprite_attack.texture = selected_weapon.texture
	player.sprite_attack.visible = true
	player.movement.lock_direction = true
	Audio.play_spatial_sound(sound, player.global_position)
	
func exit() -> void:
	player.animation.animation_player.animation_finished.disconnect(_on_animation_finished)
	player.animation.animation_player.clear_queue()
	player.movement.lock_direction = false
	player.sprite_attack.visible = false
	player.attack_area.activate(false)
	next_state = null

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("roll"):
		return roll

	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null
	
func process(_delta: float) -> PlayerState:
	return next_state

func can_enter() -> bool:
	return true

func _on_animation_finished(_animation_name: String) -> void:
	next_state = idle

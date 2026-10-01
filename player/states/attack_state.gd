class_name PlayerAttackState extends PlayerState

@export var sound: AudioStream

var selected_weapon: WeaponData
var timer := 0.0

func init() -> void:
	player.sprite_attack.visible = false


func enter() -> void:
	if player.is_using_tool:
		selected_weapon = player.inventory.current_tool
	else:
		selected_weapon = player.inventory.current_weapon
	
	if not selected_weapon:
		next_state = idle
		return

	timer = 0
	player.attack_area.damage = selected_weapon.damage
	player.attack_area.type = selected_weapon.type
	player.animation.play("attack")
	player.animation.animation_player.seek(0)
	player.animation.animation_player.animation_finished.connect(_on_animation_finished)
	player.sprite_attack.texture = selected_weapon.texture
	player.sprite_attack.visible = true
	player.movement.lock_direction = true
	Audio.play_spatial_sound(sound, player.global_position)


func exit() -> void:
	if player.animation.animation_player.animation_finished.is_connected(_on_animation_finished):
		player.animation.animation_player.animation_finished.disconnect(_on_animation_finished)
	player.animation.animation_player.clear_queue()
	player.movement.lock_direction = false
	player.sprite_attack.visible = false
	player.attack_area.activate(false)
	next_state = null
	selected_weapon = null


func physics_process(delta: float) -> PlayerState:
	timer += delta
	return null
	

func process(_delta: float) -> PlayerState:
	if player.input.attack and timer >= 0.25:
		return attack

	return next_state


func can_enter() -> bool:
	return player.inventory.current_weapon or \
	(player.inventory.current_tool and player.is_using_tool)


func _on_animation_finished(_animation_name: String) -> void:
	next_state = idle

class_name PlayerAttackState extends PlayerState

const WEAPONS := {
	"axe": "uid://c75as5cuma22p",
	"katana": "uid://bden8i5f5wdrs",
	"pickaxe": "uid://d1ihaoqhyix5j"
}

@export var cooldown := 0.001
@export var sound: AudioStream

var next_attack_time := 0.0
var selected_weapon := WEAPONS.katana

func init() -> void:
	player.sprite_attack.visible = false
	
func enter() -> void:
	player.animation.play("attack")
	player.animation.animation_player.animation_finished.connect(_on_animation_finished)
	player.sprite_attack.texture = load(selected_weapon)
	player.sprite_attack.visible = true
	player.movement.lock_direction = true
	# Audio.play_spatial_sound(sound_effect, player.attack_area.global_position, false, true)
	
func exit() -> void:
	player.animation.animation_player.animation_finished.disconnect(_on_animation_finished)
	player.animation.animation_player.clear_queue()
	player.movement.lock_direction = false
	player.sprite_attack.visible = false
	next_state = null

func handle_input(_event: InputEvent) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null
	
func process(_delta: float) -> PlayerState:
	return next_state

func can_enter() -> bool:
	return true

func _on_animation_finished(_animation_name: String) -> void:
	next_state = idle

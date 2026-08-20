@tool
@icon("/assets/icons/icon_destroyable.png")
extends CharacterBody2D
class_name Breakable

var push_velocity := Vector2.ZERO

@onready var health: HealthComponent = $HealthComponent
@onready var damage_area: DamageArea = $DamageArea
@onready var particle: Particle = $Particle
@onready var sprite: Sprite2D = $Sprite

@export var sound: AudioStream

func _ready() -> void:
	damage_area.damage_taken.connect(take_damage)
	health.died.connect(destroy)
	collision_layer = 0

func take_damage(attack_area: AttackArea):
	health.damage(attack_area.damage)
	damage_fx()

func push(from, force: int):
	push_velocity += from.direction_to(global_position) * force

func damage_fx():
	flash()
	particle.restart()
	await shake()

func shake(intensity := 1.0, time := 0.1):
	var tween = create_tween()
	tween.tween_property(sprite, "offset", Vector2(-1, -1) * intensity, time / 3)
	tween.tween_property(sprite, "offset", Vector2.LEFT * intensity, time / 3)
	tween.tween_property(sprite, "offset", Vector2.ZERO, time / 3)
	await tween.finished

func flash(time := 0.2):
	sprite.modulate = Color(5, 5, 5)
	await get_tree().create_timer(time).timeout
	sprite.modulate = Color.WHITE

func destroy():
	if sound:
		Audio.play_spatial_sound(sound, global_position)

	collision_layer = 0
	await damage_fx()
	sprite.visible = false
	damage_area.disable()
	await get_tree().create_timer(2.0).timeout
	queue_free()

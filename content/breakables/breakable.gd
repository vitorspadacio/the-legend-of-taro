@tool
@icon("res://assets/icons/breakable.svg")
class_name Breakable extends CharacterBody2D

@onready var damage_area: DamageArea = $DamageArea
@onready var health: HealthComponent = $HealthComponent
@onready var loot_dropper: LootDropper = $LootDropper
@onready var particle: Particle = $Particle
@onready var sprite: Sprite2D = $Sprite

@export var sound: AudioStream

func _ready() -> void:
	collision_layer = 0
	damage_area.damage_taken.connect(take_damage)
	health.died.connect(_on_died)


func take_damage(attack_area: AttackArea):
	health.damage(attack_area.damage)
	damage_fx()


func damage_fx():
	flash()
	particle.restart()
	await shake()


func flash(time := 0.2):
	sprite.modulate = Color(5, 5, 5)
	await get_tree().create_timer(time).timeout
	sprite.modulate = Color.WHITE


func shake(intensity := 1.0, time := 0.1):
	var tween = create_tween()
	tween.tween_property(sprite, "offset", Vector2(-1, -1) * intensity, time / 3)
	tween.tween_property(sprite, "offset", Vector2.LEFT * intensity, time / 3)
	tween.tween_property(sprite, "offset", Vector2.ZERO, time / 3)
	await tween.finished


func _on_died():
	if sound:
		Audio.play_spatial_sound(sound, global_position)

	loot_dropper.drop_loot()
	collision_layer = 0
	await damage_fx()
	sprite.visible = false
	damage_area.disable()
	await get_tree().create_timer(2.0).timeout
	queue_free()

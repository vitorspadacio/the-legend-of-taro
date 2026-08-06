@icon("res://assets/icons/attack_area.svg")
class_name AttackArea extends Area2D

@export var damage := 1.0
@export var damage_sound: AudioStream

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	monitorable = false
	monitoring = false
	visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is DamageArea:
		body.take_damage(self)
		# var effect_position: Vector2 = global_position
		# effect_position.x = body.global_position.x
		# VisualEffects.hit_dust(effect_position)
		# Audio.play_spatial_sound(sound_effect, effect_position)

func activate(duration: float = 0.1) -> void:
	set_active(true)
	await get_tree().create_timer(duration).timeout
	set_active(false)

func set_active(value: bool) -> void:
	monitoring = value
	visible = value

class_name SlimeEnemy extends CharacterBody2D

@export var contact_damage := 1.0
@export var knockback_speed := 450.0
@export var recovery_time := 0.35

@onready var damage_area: DamageArea = $DamageArea
@onready var hazard_area: HazardArea = $HazardArea
@onready var animation: AnimationComponent = $Components/AnimationComponent
@onready var health: HealthComponent = $Components/HealthComponent
@onready var movement: MovementComponent = $Components/MovementComponent
@onready var sprite: Sprite2D = $Sprite2D

var player: Player
var recovery_timer := 0.0

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player") as Player
	hazard_area.damage = contact_damage
	damage_area.damage_taken.connect(_on_damage_taken)
	health.died.connect(_on_death)

func _physics_process(_delta: float) -> void:
	if recovery_timer > 0.0:
		recovery_timer = maxf(recovery_timer - _delta, 0.0)
		movement.direction = Vector2.ZERO
		movement.move()
		animation.direction_name = movement.direction_name
		animation.play("idle")
		return

	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Player

	if is_instance_valid(player):
		movement.direction = global_position.direction_to(player.global_position)
	else:
		movement.direction = Vector2.ZERO

	movement.move()
	animation.direction_name = movement.direction_name
	animation.play("walk" if movement.direction != Vector2.ZERO else "idle")

func _on_damage_taken(attack_area: AttackArea) -> void:
	var knockback_direction := (global_position - attack_area.global_position).normalized()
	if knockback_direction == Vector2.ZERO:
		knockback_direction = Vector2.DOWN

	movement.knockback(knockback_speed, knockback_direction)
	recovery_timer = recovery_time
	health.damage(int(attack_area.damage))
	flash_red()

func flash_red() -> void:
	var tween := create_tween()
	for i in 3:
		tween.tween_property(self, "modulate", Color.RED, 0.06)
		tween.tween_property(self, "modulate", Color.WHITE, 0.06)

func _on_death() -> void:
	queue_free()

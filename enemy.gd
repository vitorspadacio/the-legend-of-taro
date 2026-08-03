extends CharacterBody2D

@onready var damage_area: DamageArea = $DamageArea
@onready var sprite: Sprite2D = $Sprite2D

@onready var health: HealthComponent = $HealthComponent
@onready var movement: MovementComponent = $MovementComponent

func _ready() -> void:
	damage_area.damage_taken.connect(_on_damage_taken)
	health.died.connect(_on_death)

func _physics_process(_delta: float) -> void:
	movement.move()

func _on_damage_taken(attack_area: AttackArea) -> void:
	var direction = (self.global_position - attack_area.global_position).normalized()
	movement.knockback(300, direction)
	health.damage(attack_area.damage)
	flash_red()

func flash_red():
	var tween = create_tween()
	for i in 3:
		tween.tween_property(self, "modulate", Color.RED, 0.06)
		tween.tween_property(self, "modulate", Color.WHITE, 0.06)

func _on_death() -> void:
	queue_free()

extends Sprite2D

@onready var damage_area: DamageArea = $DamageArea

func _ready() -> void:
	damage_area.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(attack_area: AttackArea) -> void:
	print("Tomou dano")
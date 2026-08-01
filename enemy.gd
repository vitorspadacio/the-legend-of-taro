extends Sprite2D

@onready var damage_area: DamageArea = $DamageArea

var hp := 5.0

func _ready() -> void:
	damage_area.damage_taken.connect(_on_damage_taken)

func _process(_delta: float) -> void:
	if hp <= 0:
		queue_free()

func _on_damage_taken(attack_area: AttackArea) -> void:
	hp -= attack_area.damage
	print("Tomou dano. HP total: %s" % hp)
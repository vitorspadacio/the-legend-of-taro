@icon("res://assets/icons/damage_area.svg")
class_name DamageArea extends Area2D

@export var limit_by_type := WeaponData.WeaponTypes.NONE

signal damage_taken(attack_area)

func take_damage(attack_area: AttackArea) -> void:
	if attack_area.type == limit_by_type:
		damage_taken.emit(attack_area)
	elif limit_by_type == WeaponData.WeaponTypes.NONE:
		damage_taken.emit(attack_area)


func make_invulnerable(duration: float = 1.0) -> void:
	start_invulnerable()
	await get_tree().create_timer(duration).timeout
	end_invulnerable()


func start_invulnerable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func end_invulnerable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func disable() -> void:
	monitorable = false
	monitoring = false
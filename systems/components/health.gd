class_name HealthComponent extends Node

signal health_changed(current_health: int, max_health: int)
signal died

@export var max_health := 100
var current_health := 0

func _ready() -> void:
	current_health = max_health

func damage(amount: int) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	_emit()
	if current_health == 0:
		died.emit()

func heal(amount: int) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	_emit()

func _emit() -> void:
	print(current_health)
	health_changed.emit(current_health, max_health)

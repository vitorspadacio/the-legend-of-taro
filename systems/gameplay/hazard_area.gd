@icon("res://assets/icons/hazard_area.svg")
class_name HazardArea extends AttackArea

func _ready() -> void:
	super()
	monitoring = true
	visible = true
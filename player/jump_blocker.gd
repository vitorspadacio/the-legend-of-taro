class_name JumpBlocker extends RayCast2D

func _ready() -> void:
	var parent = get_parent()
	if parent is Player:
		parent.movement.direction_changed.connect(_on_direction_changed)
	if parent is Enemy:
		parent.movement.direction_changed.connect(_on_direction_changed)

func _on_direction_changed(direction: Vector2) -> void:
	rotation = Vector2.DOWN.angle_to(direction.normalized())

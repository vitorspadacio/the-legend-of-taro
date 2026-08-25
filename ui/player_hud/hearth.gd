class_name Heart extends Control

@onready var sprite: Sprite2D = $Sprite2D

func set_state(state: int) -> void:
	sprite.frame = clampi(state, 0, 4)


func pulse() -> void:
	var tween := create_tween()

	sprite.scale = Vector2.ONE

	tween.tween_property(
		sprite,
		"scale",
		Vector2(1.2, 1.2),
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		sprite,
		"scale",
		Vector2.ONE,
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
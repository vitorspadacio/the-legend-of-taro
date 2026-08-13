class_name Effect extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("effect")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_name: String) -> void:
	queue_free()
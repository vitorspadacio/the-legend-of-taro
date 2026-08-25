class_name ItemData extends Resource

@export var description: String
@export var effect: Callable
@export var icon: Texture2D
@export var id: int
@export var name: String

func use() -> void:
	if effect.is_valid():
		effect.call()

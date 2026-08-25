class_name Pickable extends CharacterBody2D

@export var amount: int = 1
@export var item: ItemData
@export var sound: AudioStream
@export var sprite: Sprite2D

@export_group("Float")
@export var float_height := 3.0
@export var float_speed := 2.0

@onready var area: Area2D = $Area2D

var friction := 500.0
var start_y := 0.0
var time := 0.0

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	start_y = sprite.position.y
	time = randf_range(0.0, TAU)


func _process(delta: float) -> void:
	time += delta * float_speed
	sprite.position.y = start_y + sin(time) * float_height


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()


func _on_body_entered(body: Player) -> void:
	Audio.play_spatial_sound(sound, global_position)
	VisualEffects.create_pick(global_position)
	body.inventory.add_item(item, amount)
	queue_free()

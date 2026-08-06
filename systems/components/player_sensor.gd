@icon("res://assets/icons/player_sensor.svg")
class_name PlayerSensor extends Area2D

signal player_entered
signal player_exited
signal started_searching

@export var search_duration := 2.0
# @export var use_audio_sensor: bool = true
# @export var audio_detect_distance: float = 256
# @export var min_audio_distance: float = 0.5

var enemy: Enemy
var timer: float

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	if owner is Enemy:
		enemy = owner
		set_collision_mask_value(5, true)
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)
		# enemy.direction_changed.connect(_on_direction_changed)
		# if use_audio_sensor:
		# 	Audio.player_made_sound.connect(_on_player_sound)

func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		if timer <= 0:
			player_exited.emit()
			enemy.blackboard.target = null

func _on_body_entered(n: Node2D) -> void:
	started_searching.emit()
	player_entered.emit()
	enemy.blackboard.target = n
	timer = 0

func _on_body_exited(_node: Node2D) -> void:
	player_exited.emit()
	timer = search_duration

# func _on_direction_changed(direction: float) -> void:
# 	if direction < 0:
# 		scale.x = -1
# 	elif direction > 0:
# 		scale.x = 1

# func _on_player_sound(sound_position: Vector2, volume: float) -> void:
# 	var sound_distance: float = global_position.distance_to(sound_position)
# 	var d: float = clampf(1 - sound_distance / audio_detect_distance, 0.0, 1) * 2
# 	var perceived_volume: float = volume * d
# 	if perceived_volume >= min_audio_distance:
# 		started_searching.emit()
# 		timer = search_duration
# 		enemy.blackboard.target = get_tree().get_first_node_in_group("Player")

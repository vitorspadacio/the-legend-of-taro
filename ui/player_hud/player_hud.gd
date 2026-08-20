class_name PlayerHUD
extends CanvasLayer

const HEART = preload("uid://ce2kyoasha10s")
const HP_PER_HEART := 4

@onready var hearts_container: HBoxContainer = $Hearts

var hearts: Array[Heart] = []
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.health.health_changed.connect(_on_health_changed)
		_setup_hearts()

func _setup_hearts() -> void:
	for child in hearts_container.get_children():
		child.queue_free()

	var heart_count := ceili(float(player.health.max_health) / HP_PER_HEART)

	for i in heart_count:
		var heart: Heart = HEART.instantiate()
		hearts_container.add_child(heart)
		hearts.append(heart)
	
	set_health(player.health.max_health)

func _on_health_changed(current_health: int, _m: int) -> void:
	set_health(current_health)

func set_health(health: int) -> void:
	for i in hearts.size():
		var heart_health := health - i * HP_PER_HEART
		hearts[i].set_state(get_heart_state(heart_health))

func get_heart_state(health: int) -> int:
	if health <= 0:
		return 0

	return clampi(
		ceili(float(health) / HP_PER_HEART * 4.0),
		0,
		4
	)

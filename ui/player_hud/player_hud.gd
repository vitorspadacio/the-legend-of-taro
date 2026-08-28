class_name PlayerHUD extends CanvasLayer

const HEART = preload("uid://ce2kyoasha10s")
const HP_PER_HEART := 4

@onready var hearts_container: HBoxContainer = $Hearts
@onready var gold_amount: Label = $Money/Amount

var hearts: Array[Heart] = []
var player: Player

func _ready() -> void:
		await _wait_for_player()
		_setup_hearts()
		_setup_money()
		player.health.health_changed.connect(_on_health_changed)
		player.inventory.gold_changed.connect(_on_gold_changed)


func _wait_for_player() -> void:
	while player == null:
		player = get_tree().get_first_node_in_group("player")
		if not player:
			await get_tree().process_frame


func _setup_hearts() -> void:
	for child in hearts_container.get_children():
		child.queue_free()

	var heart_count := ceili(float(player.health.max_health) / HP_PER_HEART)

	for i in heart_count:
		var heart: Heart = HEART.instantiate()
		hearts_container.add_child(heart)
		hearts.append(heart)
	
	set_health(player.health.max_health)


func _setup_money() -> void:
	gold_amount.text = "%s" % player.inventory.get_gold_amount()


func _on_health_changed(current_health: int, _m: int) -> void:
	set_health(current_health)


func set_health(health: int) -> void:
	var affected_heart := -1
	for i in hearts.size():
		var heart_health := health - i * HP_PER_HEART
		var new_state := get_heart_state(heart_health)

		if hearts[i].sprite.frame != new_state:
			affected_heart = i

		hearts[i].set_state(new_state)
	
	if affected_heart >= 0:
		hearts[affected_heart].pulse()


func get_heart_state(health: int) -> int:
	if health <= 0:
		return 0

	return clampi(
		ceili(float(health) / HP_PER_HEART * 4.0),
		0,
		4
	)


func _on_gold_changed(amount: int) -> void:
	print("gold", amount)
	gold_amount.text = "%s" % amount
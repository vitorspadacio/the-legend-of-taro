@icon("res://assets/icons/state.svg")
class_name PlayerItemState extends PlayerState

var item: ItemData
var pick: Pickable

func init() -> void:
	player.item_took.connect(_on_get_item)
	player.upgrade_took.connect(_on_get_upgrade)


func enter() -> void:
	player.update_direction(Vector2.DOWN)
	player.animation.play_no_direction("pickup")
	player.animation.player.animation_finished.connect(_on_animation_finished)
	pick.global_position = player.global_position
	pick.global_position.y += 16
	player.velocity.x = 0
	player.velocity.y = 0


func exit() -> void:
	pick = null
	item = null
	next_state = null
	player.animation.player.animation_finished.disconnect(_on_animation_finished)


func process(_delta: float) -> PlayerState:
	return next_state
	

func show_item_higher() -> void:
	pick.global_position.y -= 35


func _on_animation_finished(_n: String) -> void:
	await get_tree().create_timer(2.5).timeout
	pick.delete()
	next_state = idle


func _on_get_item(item_got: ItemData, _amount: int, pick_got: Pickable) -> void:
	item = item_got
	pick = pick_got
	player.state_machine.change_state(self)


func _on_get_upgrade(pick_got: Pickable) -> void:
	pick = pick_got
	pick.visible = true
	pick.execute_effect_when_picked()
	player.state_machine.change_state(self)

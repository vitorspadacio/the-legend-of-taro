@tool
class_name Teleport extends Area2D

@export var direction = Vector2.DOWN:
	set(v):
		direction = v
		update_arrow_direction()
@export var target: Teleport

var arrow_direction: Sprite2D

func _ready() -> void:
	set_collision_mask_value(Constants.CollisionLayers.player, true)
	body_entered.connect(_on_player_entered)


func _on_player_entered(player: Player) -> void:
	player.teleport(target, Vector2(0, 20) * player.movement.direction)
	player.input.direction = direction
	target.temporary_disable()


func _draw() -> void:
	if Engine.is_editor_hint():
		if target:
			draw_line(Vector2.ZERO, target.position - position, Color.RED, 2)


func _notification(what):
	if Engine.is_editor_hint():
		match what:
			NOTIFICATION_TRANSFORM_CHANGED:
				queue_redraw()
				if target:
					target.queue_redraw()


func temporary_disable() -> void:
	set_collision_mask_value(Constants.CollisionLayers.player, false)
	await get_tree().create_timer(0.5).timeout
	set_collision_mask_value(Constants.CollisionLayers.player, true)


func update_arrow_direction():
	if Engine.is_editor_hint():
		if !arrow_direction:
			arrow_direction = Sprite2D.new()
			arrow_direction.offset.x = 8
			arrow_direction.z_index = 2
			arrow_direction.texture = load("uid://dqbrf3i20oqsy")
			add_child(arrow_direction)
		arrow_direction.rotation = direction.angle()
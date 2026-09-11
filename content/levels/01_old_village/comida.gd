extends Node2D

const BONUS_SOUND = preload("uid://fri0r25i6m5v")

@onready var dialog: DialogComponent = $DialogComponent

func _ready() -> void:
	dialog.dialog_ended.connect(_on_dialog_end)


func _on_dialog_end() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	Audio.play_spatial_sound(BONUS_SOUND, global_position)
	player.health.heal(8)
	await get_tree().create_timer(1.5).timeout

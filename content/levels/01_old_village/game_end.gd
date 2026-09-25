extends Area2D

@onready var dialog: DialogComponent = $DialogComponent

func _ready() -> void:
	body_entered.connect(_on_player_entered)


func _on_player_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	print("player entrou")
	var player = body as Player
	var camera: CameraController = get_tree().get_first_node_in_group("camera")
	camera.target = null
	player.block_input = true
	player.state_machine.change_state(player.walk)
	await get_tree().create_timer(1.0).timeout
	player.start_freeze()
	Audio.stop_music()
	await camera.fade_out(1.0)
	dialog.start_dialog()
	await dialog.dialog_ended
	print("terminou")
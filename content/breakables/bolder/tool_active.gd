class_name ToolActive extends Area2D

func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)


func _on_player_entered(body: Node2D) -> void:
	if not body is Player:
		return

	var player = body as Player
	player.is_using_tool = true


func _on_player_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	var player = body as Player
	player.is_using_tool = false

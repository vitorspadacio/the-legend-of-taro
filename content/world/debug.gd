extends Control

var katana = preload("uid://c20tij6l0ueyp")
@onready var button: Button = $Button

func _ready() -> void:
	button.pressed.connect(_on_button_clicked)


func _on_button_clicked() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.take_item(katana, 1, null)

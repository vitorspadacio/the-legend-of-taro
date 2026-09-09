extends Control

var katana = preload("uid://c20tij6l0ueyp")
var coin = preload("uid://ul36oy6ljp5j")
@onready var button: Button = $Button
@onready var button2: Button = $Button2

func _ready() -> void:
	button.pressed.connect(_on_button_clicked)
	button2.pressed.connect(_on_button_clicked2)


func _on_button_clicked() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.take_item(katana, 1, null)

func _on_button_clicked2() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.take_item(coin, 5, null)

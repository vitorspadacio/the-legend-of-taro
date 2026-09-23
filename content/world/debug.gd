extends Control

var katana = preload("uid://c20tij6l0ueyp")
var coin = preload("uid://ul36oy6ljp5j")
var picareta = preload("uid://bb01emd34as2c")
@onready var button: Button = $Button
@onready var button2: Button = $Button2
@onready var button3: Button = $Button3
@onready var button4: Button = $Button4

func _ready() -> void:
	button.pressed.connect(_on_button_clicked)
	button2.pressed.connect(_on_button_clicked2)
	button3.pressed.connect(_on_button_clicked3)
	button4.pressed.connect(_on_button_clicked4)


func _on_button_clicked() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.take_item(katana, 1, null)

func _on_button_clicked2() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.take_item(coin, 5, null)

func _on_button_clicked3() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.take_item(picareta, 1, null)
	player.inventory.equip_tool(picareta)

func _on_button_clicked4() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.has_jump = true
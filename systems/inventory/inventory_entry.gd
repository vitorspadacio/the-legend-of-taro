class_name InventoryEntry extends Resource

var item: ItemData
var quantity: int

func _init(
	i_item: ItemData,
	i_quantity: int) -> void:
		item = i_item
		quantity = i_quantity

class_name InventoryEntry extends Resource

@export var item: ItemData
@export var quantity: int

func _init(
	i_item: ItemData,
	i_quantity: int) -> void:
		item = i_item
		quantity = i_quantity

class_name Inventory extends Resource

var current_weapon: ItemData
var items: Array[InventoryEntry] = []

func add_item(item: ItemData, amount: int = 1) -> void:
	for entry in items:
		if entry.item.id == item.id:
			entry.quantity += amount
			return

	var entry := InventoryEntry.new(item, amount)
	items.append(entry)


func use_item(index: int) -> void:
	items[index].use()

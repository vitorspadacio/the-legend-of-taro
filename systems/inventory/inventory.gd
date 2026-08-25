class_name Inventory extends Resource

var current_weapon: WeaponData = null
var items: Array[InventoryEntry] = []

func add_item(item: ItemData, amount: int = 1) -> void:
	for entry in items:
		if entry.item.id == item.id:
			entry.quantity += amount
			return

	var entry := InventoryEntry.new(item, amount)
	items.append(entry)

	if item is WeaponData and not current_weapon:
		equip_weapon(item)


func equip_weapon(weapon_to_equip: WeaponData) -> void:
	current_weapon = weapon_to_equip

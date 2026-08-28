class_name Inventory extends Resource

signal gold_changed(amount: int)

var current_weapon: WeaponData = null
var items: Array[InventoryEntry] = []

func add_item(item: ItemData, amount: int = 1) -> void:
	for entry in items:
		if entry.item.id == item.id:
			entry.quantity += amount
			update_weapon_and_gold(item)
			return
	
	var new_entry := InventoryEntry.new(item, amount)
	items.append(new_entry)
	update_weapon_and_gold(item)
	

func update_weapon_and_gold(item: ItemData) -> void:
	if item.id == 1:
		gold_changed.emit(get_gold_amount())

	if item is WeaponData and not current_weapon:
		equip_weapon(item)


func equip_weapon(weapon_to_equip: WeaponData) -> void:
	current_weapon = weapon_to_equip


func get_gold_amount() -> int:
	for item in items:
		if item.item.id == 1:
			return item.quantity

	return 0

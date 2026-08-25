class_name WeaponData extends ItemData

enum WeaponTypes {
	NONE = 0,
	SWORD = 1,
	PICKAXE = 2,
}

@export var damage: int
@export var damage_bonus: int
@export var texture: CompressedTexture2D
@export var type: WeaponTypes

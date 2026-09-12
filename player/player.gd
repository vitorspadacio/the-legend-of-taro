class_name Player extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)
signal item_took(item: ItemData, amount: int, Pick: Pickable)
signal upgrade_took(Pick: Pickable)

signal died
signal freeze
signal teleported
signal death_end

@export var attack_area: AttackArea
@export var collision: CollisionShape2D
@export var damage_area: DamageArea
@export var sprite: Sprite2D
@export var sprite_attack: Sprite2D
@export var state_machine: StateMachine
@export var raycast_2d: RayCast2D

@export_category("components")
@export var animation: AnimationComponent
@export var health: HealthComponent
@export var input: InputComponent
@export var jump: JumpComponent
@export var movement: MovementComponent

@onready var idle: PlayerState = %Idle

var block_input := false
var block_dialog := false

var inventory: Inventory
var respawn: Teleport

var has_jump := false
var has_roll := false

##### Core #####

func _ready() -> void:
	inventory = Inventory.new()
	state_machine.init_player(self)
	damage_area.damage_taken.connect(_on_damage_taken)
	health.died.connect(died.emit)
	jump.height_changed.connect(_on_height_changed)

func _process(delta: float) -> void:
	if not block_input:
		input.update_commands()
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

##### Functions #####

func update_direction(force_direction: Vector2 = Vector2.ZERO) -> void:
	if force_direction == Vector2.ZERO:
		movement.direction = input.direction
	else:
		movement.update_direction(force_direction)
	animation.direction_name = movement.direction_name
	animation.play()

func take_item(item: ItemData, amount: int, pick: Pickable, should_emit: bool = false) -> void:
	if should_emit:
		item_took.emit(item, amount, pick)
	inventory.add_item(item, amount)

func take_upgrade(pick: Pickable) -> void:
	has_jump = true
	upgrade_took.emit(pick)

func teleport(target: Teleport, offset_position: Vector2) -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	await camera.fade_out()
	global_position = target.global_position + offset_position
	await camera.teleport_to(target.global_position)
	await camera.fade_in()
	teleported.emit()

func start_freeze() -> void:
	block_input = true
	input.direction = Vector2.ZERO
	freeze.emit()

func end_freeze() -> void:
	block_input = false

func respawn_player() -> void:
	health.heal(8)
	await teleport(respawn, Vector2.ZERO)
	input.direction = Vector2.DOWN
	state_machine.change_state(idle)
	VisualEffects.create_smoke(global_position)
	await get_tree().create_timer(0.5).timeout
	visible = true

func drop_coins() -> void:
	var drop_count = inventory.remove_random_coins()
	print(drop_count)
	var drop_scene = load("uid://cbosspiox8efp")
	for j in drop_count:
		var drop = drop_scene.instantiate()
		get_tree().current_scene.add_sibling.call_deferred(drop)
		drop.global_position = global_position
		if drop is CharacterBody2D:
			var x = randf_range(-40, 40)
			var y = randf_range(-40, -60)
			drop.velocity = Vector2(x, y)

##### Side Effects #####

func _on_damage_taken(attacker_area: AttackArea) -> void:
	health.damage(attacker_area.damage)
	damage_taken.emit(attacker_area)

func _on_height_changed(height: float) -> void:
	sprite.position.y = - height

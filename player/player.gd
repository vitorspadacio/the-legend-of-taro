class_name Player extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)
signal died()

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

var inventory: Inventory

##### Core #####

func _ready() -> void:
	inventory = Inventory.new()
	state_machine.init_player(self)
	damage_area.damage_taken.connect(_on_damage_taken)
	health.died.connect(died.emit)
	jump.height_changed.connect(_on_height_changed)

func _process(delta: float) -> void:
	input.update_commands()
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

##### Functions #####

func update_direction() -> void:
	movement.direction = input.direction
	animation.direction_name = movement.direction_name
	animation.play()

##### Side Effects #####

func _on_damage_taken(attacker_area: AttackArea) -> void:
	health.damage(attacker_area.damage)
	damage_taken.emit(attacker_area)

func _on_height_changed(height: float) -> void:
	sprite.position.y = - height
